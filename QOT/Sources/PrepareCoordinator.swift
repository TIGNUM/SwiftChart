//
//  RootPrepareCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 29.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import LoremIpsum
import EventKit
import EventKitUI

final class PrepareCoordinator: ParentCoordinator {

    struct Context {
        let contentID: Int
        let listTitle: String

        var defaultPreparationName: String {
            let dateString = DateFormatter.shortDate.string(from: Date())
            return "My \(listTitle) Prep // \(dateString)"
        }
    }

    // MARK: Private properties

    var children: [Coordinator] = []


    fileprivate let services: Services
    fileprivate let tabBarController: TabBarController
    fileprivate let topTabBarController: TopTabBarController
    fileprivate let chatViewController: ChatViewController<Answer>
    fileprivate let myPrepViewController: MyPrepViewController
    fileprivate let chatDecisionManager: PrepareChatDecisionManager
    fileprivate var context: Context?

    fileprivate weak var prepareListViewController: PrepareContentViewController?

    fileprivate lazy var editEventHandler: EditEventHandler = {
        let delegate = EditEventHandler()
        delegate.handler = { [weak self] (controller, action) in
            switch action {
            case .saved:
                if let event = controller.event {
                    self?.createPreparation(name: event.title, eventID: event.eventIdentifier)
                }
                self?.tabBarController.dismiss(animated: true)
                self?.chatDecisionManager.start()
            case .canceled, .deleted:
                controller.dismiss(animated: true)
            }
        }
        return delegate
    }()

    init(services: Services,
         tabBarController: TabBarController,
         topTabBarController: TopTabBarController,
         chatViewController: ChatViewController<Answer>,
         myPrepViewController: MyPrepViewController) {
        self.services = services
        self.tabBarController = tabBarController
        self.topTabBarController = topTabBarController
        self.chatViewController = chatViewController
        self.chatDecisionManager = PrepareChatDecisionManager(service: services.questionsService)
        self.myPrepViewController = myPrepViewController

        chatDecisionManager.delegate = self
        chatViewController.didSelectChoice = { [weak self] (choice, viewController) in
            self?.chatDecisionManager.didSelectChoice(choice)
        }

        myPrepViewController.delegate = self
    }

    func start() {
        
    }

    func focus() {
        chatDecisionManager.start()
    }
}

private extension PrepareCoordinator {

    func showPrepareList(contentID: Int) {
        var title: String? = nil
        var video: PrepareContentViewModel.Video? = nil
        var items: [PrepareItem] = []
        for item in services.contentService.contentItems(contentID: contentID) {
            let value = item.contentItemValue
            switch value {
            case .text(let text, style: .h1):
                title = text
            case .prepareStep(let title, let description, let relatedContentID):
//                items.append(PrepareItem(id: item.remoteID, title: title, subTitle: description, readMoreID: relatedContentID))
                //TODO: use relatedContentID instead of 100000 when data is available
                items.append(PrepareItem(id: item.remoteID, title: title, subTitle: description, readMoreID: 100000))
            case .video(_, _, let placeholderURL, let videoURL, _):
                video = PrepareContentViewModel.Video(url: videoURL, placeholderURL: placeholderURL)
            default:
                break
            }
        }

        if let title = title {
            let viewModel = PrepareContentViewModel(title: title, subtitle: "", video: video, description: "", items: items)
            let viewController = PrepareContentViewController(viewModel: viewModel)
            viewController.delegate = self
            tabBarController.present(viewController, animated: true)
            prepareListViewController = viewController

            context = Context(contentID: contentID, listTitle: title)
        } else {
            tabBarController.showAlert(type: .noContent, handler: { [weak self] in
                self?.chatDecisionManager.start()
            }, handlerDestructive: nil)
        }
    }

    func showPrepareCheckList(preparationID: String) {
        guard let preparation = services.preparationService.preparation(localID: preparationID) else {
            return
        }

        var title: String? = nil
        var video: PrepareContentViewModel.Video? = nil
        var items: [PrepareItem] = []
        for item in services.contentService.contentItems(contentID: preparation.contentID) {
            let value = item.contentItemValue
            switch value {
            case .text(let text, style: .h1):
                title = text
            case .prepareStep(let title, let description, let relatedContentID):
                items.append(PrepareItem(id: item.remoteID, title: title, subTitle: description, readMoreID: relatedContentID))
            case .video(_, _, let placeholderURL, let videoURL, _):
                video = PrepareContentViewModel.Video(url: videoURL, placeholderURL: placeholderURL)
            default:
                break
            }
        }

        let preparationChecks = services.preparationService.preparationChecks(preparationID: preparationID)
        var checkedIDs: [Int: Date] = [:]
        for preparationCheck in preparationChecks {
            checkedIDs[preparationCheck.contentItemID] = preparationCheck.timestamp
        }

        if let title = title {
            let viewModel = PrepareContentViewModel(title: title,
                                                    video: video,
                                                    description: "",
                                                    items: items,
                                                    checkedIDs: checkedIDs,
                                                    preparationID: preparationID)

            let viewController = PrepareContentViewController(viewModel: viewModel)
            viewController.delegate = self
            tabBarController.present(viewController, animated: true)
            prepareListViewController = viewController
        } else {
            tabBarController.showAlert(type: .noContent, handler: { [weak self] in
                self?.chatDecisionManager.start()
                }, handlerDestructive: nil)
        }
    }

    func showCreatePreparation(from viewController: PrepareContentViewController) {
        guard let context = context else {
            preconditionFailure("No preparation context")
        }

        let start = Date()
        let finish = start.addingTimeInterval(TimeInterval(days: 30))
        let events = services.eventsService.ekEvents(from: start, to: finish)

        let viewModel = PrepareEventsViewModel(preparationTitle: context.defaultPreparationName, events: events)
        let prepareEventsVC = PrepareEventsViewController(viewModel: viewModel)
        prepareEventsVC.delegate = self
        prepareEventsVC.modalPresentationStyle = .custom
        prepareEventsVC.modalTransitionStyle = .crossDissolve

        viewController.present(prepareEventsVC, animated: true)
    }

    func createPreparation(name: String, eventID: String?) {
        guard let context = context else {
            preconditionFailure("No preparation context")
        }

        services.preparationService.createPreparation(contentID: context.contentID,
                                                      eventID: eventID,
                                                      title: name,
                                                      subtitle: context.listTitle,
                                                      completion: nil)
    }
}

extension PrepareCoordinator: PrepareContentViewControllerDelegate {
    func didTapSavePreparation(in viewController: PrepareContentViewController) {
        showCreatePreparation(from: viewController)
    }

    func didTapClose(in viewController: PrepareContentViewController) {
        viewController.dismiss(animated: true, completion: nil)
        chatDecisionManager.start()

        if let preparationID = viewController.viewModel.preparationID {
            let checks = viewController.viewModel.checkedIDs
            services.preparationService.updateChecks(preparationID: preparationID, checks: checks, completion: nil)
        }
    }

    func didTapVideo(with videoURL: URL, from view: UIView, in viewController: PrepareContentViewController) {
        log("didTapVideo: :")
    }

    func didTapReadMore(readMoreID: Int, in viewController: PrepareContentViewController) {
        log("didTapReadMore: ID: \(readMoreID)")

        guard let content = services.contentService.contentCollection(id: readMoreID) else {
            showReadMoreError(viewController: viewController)
            return
        }
        guard let categoryID = content.categoryIDs.first?.value else {
            showReadMoreError(viewController: viewController)
            return
        }
        // TODO: we need to use categoryID istead of 100003 when data is correct
        guard let category = services.contentService.contentCategory(id: 100003) else {
            showReadMoreError(viewController: viewController)
            return
        }

        //TODO: Show error for above guards

        let coordinator = LearnContentItemCoordinator(root: viewController, services: services, eventTracker: services.trackingService, content: content, category: category)
        startChild(child: coordinator)
    }

    private func showReadMoreError(viewController: UIViewController) {
        viewController.showAlert(type: .noContent)
    }
}

extension PrepareCoordinator : PrepareChatDecisionManagerDelegate {

    func setItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager) {
        chatViewController.viewModel.setItems(items: items)
    }

    func appendItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager) {
        chatViewController.viewModel.append(items: items)
    }

    func showContent(id: Int, manager: PrepareChatDecisionManager) {
        showPrepareList(contentID: id)
    }

    func showNoContentError(manager: PrepareChatDecisionManager) {
        tabBarController.showAlert(type: .noContent, handler: { [weak self] in
            self?.chatDecisionManager.start()
            }, handlerDestructive: nil)
    }
}
extension PrepareCoordinator: MyPrepViewControllerDelegate {

    func didTapMyPrepItem(with item: MyPrepViewModel.Item, viewController: MyPrepViewController) {
        showPrepareCheckList(preparationID: item.localID)
    }
}  

extension PrepareCoordinator: PrepareEventsViewControllerDelegate {

    func didTapClose(viewController: PrepareEventsViewController) {
        viewController.dismiss(animated: true)
    }

    func didTapAddToPrepList(viewController: PrepareEventsViewController) {
        let name = viewController.viewModel.preparationTitle
        let message = R.string.localized.alertMessageEditPreparationName()

        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = name
        }

        let saveTitle = R.string.localized.alertButtonTitleSave()
        let saveAction = UIAlertAction(title: saveTitle, style: .default) { [weak self] (_) in
            let name = alertController.textFields?.first?.text ?? ""
            self?.createPreparation(name: name, eventID: nil)
            self?.topTabBarController.dismiss(animated: true)
            self?.chatDecisionManager.start()
        }
        let cancelTitle = R.string.localized.alertButtonTitleCancel()
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true)
    }

    func didTapEvent(event: EKEvent, viewController: PrepareEventsViewController) {
        createPreparation(name: event.title, eventID: event.eventIdentifier)
        tabBarController.dismiss(animated: true)
        chatDecisionManager.start()
    }

    func didTapSavePrepToDevice(viewController: PrepareEventsViewController) {
        viewController.showAlert(type: .comingSoon)
    }

    func didTapAddNewTrip(viewController: PrepareEventsViewController) {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = services.eventsService.eventStore
        eventEditVC.editViewDelegate = editEventHandler

        viewController.present(eventEditVC, animated: true)
    }
}

private class EditEventHandler: NSObject, EKEventEditViewDelegate {

    var handler: ((EKEventEditViewController, EKEventEditViewAction) -> Void)?

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        handler?(controller, action)
    }
}
