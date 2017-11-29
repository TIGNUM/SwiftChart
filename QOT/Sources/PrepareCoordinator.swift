//
//  RootPrepareCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 29.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

final class PrepareCoordinator: ParentCoordinator {

    struct Context {
        let contentCollectionID: Int
        let listTitle: String

        var defaultPreparationName: String {
            let dateString = DateFormatter.shortDate.string(from: Date())
            return "My \(listTitle) Prep // \(dateString)"
        }
    }

    // MARK: Properties

    private let services: Services
    private let eventTracker: EventTracker
    private let permissionHandler: PermissionHandler
    private let tabBarController: TabBarController
    private let topTabBarController: UINavigationController
    private let chatViewController: ChatViewController<Answer>
    private let myPrepViewController: MyPrepViewController
    private let chatDecisionManager: PrepareChatDecisionManager
    private var context: Context?
    private weak var prepareListViewController: PrepareContentViewController?
    var children: [Coordinator] = []

    private lazy var editEventHandler: EditEventHandler = {
        let delegate = EditEventHandler()
        delegate.handler = { [weak self] (controller, action) in
            switch action {
            case .saved:
                if let event = controller.event {
                    self?.createPreparation(name: event.title, event: event)
                }
                self?.tabBarController.dismiss(animated: true)
                self?.chatDecisionManager.preparationSaved()
            case .canceled, .deleted:
                controller.dismiss(animated: true)
            }
        }
        return delegate
    }()

    init(services: Services,
         eventTracker: EventTracker,
         permissionHandler: PermissionHandler,
         tabBarController: TabBarController,
         topTabBarController: UINavigationController,
         chatViewController: ChatViewController<Answer>,
         myPrepViewController: MyPrepViewController) {
        self.services = services
        self.eventTracker = eventTracker
        self.permissionHandler = permissionHandler
        self.tabBarController = tabBarController
        self.topTabBarController = topTabBarController
        self.chatViewController = chatViewController
        self.chatDecisionManager = PrepareChatDecisionManager(service: services.questionsService)
        self.myPrepViewController = myPrepViewController
        myPrepViewController.delegate = self
        chatDecisionManager.delegate = self

        chatViewController.didSelectChoice = { [weak self] (choice, viewController) in
            self?.chatDecisionManager.didSelectChoice(choice)
        }
    }

    func start() {
    }

    func focus() {
        chatDecisionManager.start()
    }
}

extension PrepareCoordinator {

    func showPrepareList(contentCollectionID: Int) {
        var title: String? = nil
        var video: PrepareContentViewModel.Video? = nil
        var description: String?
        var items: [PrepareItem] = []

        if let content = services.contentService.contentCollection(id: contentCollectionID) {
            title = content.title
            for item in content.contentItems {
                let value = item.contentItemValue
                switch value {
                case .prepareStep(let title, let description, let relatedContentID):
                    items.append(PrepareItem(id: item.forcedRemoteID, title: title, subTitle: description, readMoreID: relatedContentID))
                case .video(_, _, let placeholderURL, let videoURL, _):
                    video = PrepareContentViewModel.Video(url: videoURL, placeholderURL: placeholderURL)
                case .text(let text, let style):
                    if style == .paragraph {
                        description = text
                    }
                default:
                    break
                }
            }
        }

        if let title = title {
            let viewModel = PrepareContentViewModel(title: title,
                                                    subtitle: "",
                                                    video: video,
                                                    description: description ?? "",
                                                    items: items)

            let viewController = PrepareContentViewController(pageName: .prepareContent, viewModel: viewModel)
            viewController.delegate = self
            tabBarController.present(viewController, animated: true)
            prepareListViewController = viewController

            context = Context(contentCollectionID: contentCollectionID, listTitle: title)
        } else {
            tabBarController.showAlert(type: .noContent, handler: { [weak self] in
                self?.chatDecisionManager.start()
            }, handlerDestructive: nil)
        }
    }

    func showPrepareCheckList(preparationID: String) {
        guard let preparation = services.preparationService.preparation(localID: preparationID) else { return }
        var title: String? = nil
        var video: PrepareContentViewModel.Video? = nil
        var description: String?
        var items: [PrepareItem] = []

        if let content = services.contentService.contentCollection(id: preparation.contentCollectionID) {
            title = content.title
            for item in content.contentItems {
                let value = item.contentItemValue
                switch value {
                case .prepareStep(let title, let description, let relatedContentID):
                    items.append(PrepareItem(id: item.forcedRemoteID, title: title, subTitle: description, readMoreID: relatedContentID))
                case .video(_, _, let placeholderURL, let videoURL, _):
                    video = PrepareContentViewModel.Video(url: videoURL, placeholderURL: placeholderURL)
                case .text(let text, let style):
                    if style == .paragraph {
                        description = text
                    }
                default:
                    break
                }
            }
        }

        let preparationChecks = services.preparationService.preparationChecks(preparationID: preparationID)
        var checkedIDs: [Int: Date?] = [:]
        for preparationCheck in preparationChecks {
            checkedIDs[preparationCheck.contentItemID] = preparationCheck.covered
        }

        if let title = title {
            let viewModel = PrepareContentViewModel(title: title,
                                                    video: video,
                                                    description: description ?? "",
                                                    items: items,
                                                    checkedIDs: checkedIDs,
                                                    preparationID: preparationID)

            let viewController = PrepareContentViewController(pageName: .prepareCheckList, viewModel: viewModel)
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
        guard let context = context else { preconditionFailure("No preparation context") }
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

    func createPreparation(name: String, event: EKEvent?) {
        guard let context = context else { preconditionFailure("No preparation context") }

        let localID: String
        do {
            localID = try services.preparationService.createPreparation(contentCollectionID: context.contentCollectionID, event: event, name: name, subtitle: context.listTitle)
        } catch {
            log(error, level: .error)
            return
        }

        guard let event = event else { return }
        self.permissionHandler.askPermissionForCalendar { (granted: Bool) in
            guard granted == true else { return }

            let eventStore = EKEventStore.shared
            var notes = event.notes ?? ""
            guard let preparationLink = URLScheme.preparationURL(withID: localID) else { return }
            notes += "\n\n" + preparationLink
            log("preparationLink: \(preparationLink)")
            event.notes = notes
            do {
                try eventStore.save(event, span: .thisEvent, commit: true)
            } catch let error {
                log("createPreparation - eventStore.save.error: \(error.localizedDescription)", level: .error)
                return
            }
        }
    }
}

// MARK: - PrepareContentViewControllerDelegate

extension PrepareCoordinator: PrepareContentViewControllerDelegate {

    func didTapSavePreparation(in viewController: PrepareContentViewController) {
        showCreatePreparation(from: viewController)
    }

    func didTapClose(in viewController: PrepareContentViewController) {
        viewController.dismiss(animated: true, completion: nil)
        UIApplication.shared.statusBarStyle = .lightContent
        chatDecisionManager.addQuestions()

        if let preparationID = viewController.viewModel.preparationID {
            let checks = viewController.viewModel.checkedIDs
            try? services.preparationService.updateChecks(preparationID: preparationID, checks: checks)
        }
    }

    func didTapReadMore(readMoreID: Int, in viewController: PrepareContentViewController) {
        log("didTapReadMore: ID: \(readMoreID)")

        guard let content = services.contentService.contentCollection(id: readMoreID) else {
            showReadMoreError(viewController: viewController)
            return
        }
        guard let/* categoryID*/_ = content.categoryIDs.first?.value else {
            showReadMoreError(viewController: viewController)
            return
        }
        // TODO: we need to use categoryID istead of 100003 when data is correct
        guard let category = services.contentService.contentCategory(id: 100003) else {
            showReadMoreError(viewController: viewController)
            return
        }

        //TODO: Show error for above guards

        let coordinator = LearnContentItemCoordinator(root: viewController, eventTracker: eventTracker, services: services, content: content, category: category)
        startChild(child: coordinator)
    }

    private func showReadMoreError(viewController: UIViewController) {
        viewController.showAlert(type: .noContent)
    }
}

extension PrepareCoordinator: PrepareChatDecisionManagerDelegate {

    func setItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager) {
        chatViewController.viewModel.setItems(items)
    }

    func appendItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager) {
        chatViewController.viewModel.appendItems(items)
    }

    func showContent(id: Int, manager: PrepareChatDecisionManager) {
        showPrepareList(contentCollectionID: id)
    }

    func showNoContentError(manager: PrepareChatDecisionManager) {
        tabBarController.showAlert(type: .noContent, handler: { [weak self] in
            self?.chatDecisionManager.addQuestions()
            }, handlerDestructive: nil)
    }
}

// MARK: - MyPrepViewControllerDelegate

extension PrepareCoordinator: MyPrepViewControllerDelegate {

    func didTapMyPrepItem(with item: MyPrepViewModel.Item, viewController: MyPrepViewController) {
        showPrepareCheckList(preparationID: item.localID)
    }
}

// MARK: - PrepareEventsViewControllerDelegate

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
            self?.createPreparation(name: name, event: nil)
            self?.topTabBarController.dismiss(animated: true)
            self?.chatDecisionManager.preparationSaved()
        }
        let cancelTitle = R.string.localized.alertButtonTitleCancel()
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true)
    }

    func didTapEvent(event: EKEvent, viewController: PrepareEventsViewController) {
        createPreparation(name: event.title, event: event)
        tabBarController.dismiss(animated: true)
        chatDecisionManager.preparationSaved()
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
