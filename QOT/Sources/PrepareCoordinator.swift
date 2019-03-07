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
import MBProgressHUD
import RealmSwift

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
    private let widgetDataManager: ExtensionsDataManager
    private let eventTracker: EventTracker
    private let permissionsManager: PermissionsManager
    private let tabBarController: TabBarController
    private var topTabBarController: UINavigationController
    private let chatViewController: ChatViewController<PrepareAnswer>
    private let myPrepViewController: MyPrepViewController
    private let chatDecisionManager: PrepareChatDecisionManager
    private let rightBarButtonItem = UIBarButtonItem.info
    private var prepareContentNoteController: PrepareContentNotesViewController?
    private var context: Context?
    private var contentTitle = ""
    private var preparationID = ""
    private var contentCollectionID = 0
    private weak var prepareListViewController: PrepareContentViewController?
    private var viewModel: PrepareContentViewModel?
    var children: [Coordinator] = []

    private lazy var editEventHandler: EditEventHandler = {
        let delegate = EditEventHandler()
        delegate.handler = { [weak self] (controller, action) in
            switch action {
            case .saved:
                if let ekEvent = controller.event {
                    self?.createPreparation(with: ekEvent)
                }
            case .canceled, .deleted:
                controller.dismiss(animated: true)
            }
        }
        return delegate
    }()

    init(services: Services,
         eventTracker: EventTracker,
         permissionsManager: PermissionsManager,
         tabBarController: TabBarController,
         topTabBarController: UINavigationController,
         chatViewController: ChatViewController<PrepareAnswer>,
         myPrepViewController: MyPrepViewController) {
        self.services = services
        self.eventTracker = eventTracker
        self.permissionsManager = permissionsManager
        self.widgetDataManager = ExtensionsDataManager(services: services)
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
        let problemCategoryID: Int = 100032 // FIXME: Should be set based on settings
        var title: String? = nil
        var video: PrepareContentViewModel.Video? = nil
        var description: String?
        var subtitle: String?
        var items: [PrepareItem] = []
        var viewControllerTitle = R.string.localized.topTabBarItemTitlePerparePrep()
        var categoryID = 0
        var prepType: PreparationContentType = .prepContentEvent
        if let content = services.contentService.contentCollection(id: contentCollectionID) {
            viewControllerTitle = content.contentCategories.first?.title ?? viewControllerTitle
            categoryID = content.contentCategories.first?.forcedRemoteID ?? categoryID
            prepType = (categoryID != problemCategoryID) ? .prepContentEvent : .prepContentProblem
            title = content.title

            for item in content.contentItems {
                let value = item.contentItemValue
                switch value {
                case .prepareStep(let title, let description, let relatedContentID):
                    items.append(PrepareItem(id: item.forcedRemoteID,
                                             title: title,
                                             subTitle: description,
                                             readMoreID: relatedContentID))
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

            if prepType == .prepContentProblem {
                let videoItem = content.contentItems.filter { $0.format == "video" }.first
                description = videoItem?.valueText
                subtitle = videoItem?.valueDescription
            }
        }

        if let title = title {
            let viewModel = PrepareContentViewModel(type: prepType,
                                                    title: title,
                                                    subtitle: subtitle ?? "",
                                                    video: video,
                                                    description: description ?? "",
                                                    items: items,
                                                    services: services)
            let viewController = PrepareContentViewController(viewModel: viewModel)
            PrepareContentViewController.pageName = .prepareContent
            viewController.delegate = self
            viewController.title = viewControllerTitle
            tabBarController.present(viewController, animated: true)
            prepareListViewController = viewController
            context = Context(contentCollectionID: contentCollectionID, listTitle: title)
        } else {
            tabBarController.showAlert(type: .noContent, handler: { [weak self] in
                self?.chatDecisionManager.start()
            })
        }
    }

    func showPrepareCheckList(preparationID: String,
                              chatDecisionManager: PrepareChatDecisionManager? = nil,
                              progressHUD: MBProgressHUD? = nil) {
        guard let preparation = services.preparationService.preparation(localID: preparationID) else { return }
        self.preparationID = preparationID
        if let viewModel = prepareChecklistViewModel(preparation: preparation) {
            let prepareController = PrepareContentViewController(viewModel: viewModel,
                                                                 chatDecisionManager: chatDecisionManager,
                                                                 progressHUD: progressHUD)
            PrepareContentViewController.pageName = .prepareCheckList
            prepareController.delegate = self
            prepareController.title = R.string.localized.topTabBarItemTitlePerparePreparation()
            let storyboard = R.storyboard.reviewNotesViewController()
            guard let noteController = storyboard.instantiateInitialViewController() as? PrepareNotesViewController else { return }
            noteController.viewModel = viewModel
            noteController.title = R.string.localized.topTabBarItemTitlePerpareNotes()
            topTabBarController = UINavigationController(withPages: [prepareController, noteController],
                                                         navigationItem: NavigationItem(),
                                                         topBarDelegate: self,
                                                         leftButton: UIBarButtonItem(withImage: R.image.ic_close()),
                                                         rightButton: rightBarButtonItem,
                                                         navigationItemStyle: Date().isNight ? .dark : .light)
            topTabBarController.navigationBar.barTintColor = .nightModeBackground
            topTabBarController.navigationBar.shadowImage = UIImage()
            tabBarController.viewControllers?.last?.present(topTabBarController, animated: true)
            prepareListViewController = prepareController
            self.viewModel = viewModel
        } else {
            tabBarController.showAlert(type: .noContent, handler: { [weak self] in
                self?.chatDecisionManager.start()
            })
        }
    }

    func showCreatePreparation(from viewController: UIViewController, contentCollectionID: Int) {
        guard let content = services.contentService.contentCollection(id: contentCollectionID) else { return }
        self.contentCollectionID = contentCollectionID
        let start = Date()
        let finish = start.addingTimeInterval(TimeInterval(days: 30))
        let events = services.eventsService.calendarEvents(from: start, to: finish)
        let calendarsOnDevice = services.eventsService.syncSettingsManager.calendarIdentifiersOnThisDevice
        let synchronisedCalendars = services.eventsService.syncSettingsManager.calendarSyncSettings.compactMap {
            return $0.syncEnabled && calendarsOnDevice.contains($0.identifier) ? $0.identifier : nil
        }
        let viewModel = PrepareEventsViewModel(preparationTitle: content.title,
                                               events: events,
                                               calendarIdentifiers: synchronisedCalendars)
        let prepareEventsVC = PrepareEventsViewController(viewModel: viewModel)
        prepareEventsVC.delegate = self
        prepareEventsVC.modalPresentationStyle = .custom
        prepareEventsVC.modalTransitionStyle = .crossDissolve
        viewController.present(prepareEventsVC, animated: true)
    }

    func createPreparation(name: String?, event: CalendarEvent?, completion: ((String?) -> Void)? = nil) {
        guard
            let name = name,
            let title = services.contentService.contentCollection(id: contentCollectionID)?.title
            else { preconditionFailure("No preparation name or title") }
        let context = Context(contentCollectionID: contentCollectionID, listTitle: title)
        do {
            let localID = try services.preparationService.createPreparation(contentCollectionID: context.contentCollectionID,
                                                                            event: event,
                                                                            name: name,
                                                                            subtitle: context.listTitle)
            completion?(localID)
            self.addPreparationLink(preparationID: localID, preperationName: name, calendarEvent: event)
        } catch {
            log(error, level: .error)
            return
        }

    }

    func addPreparationLink(preparationID: String?, preperationName: String?, calendarEvent: CalendarEvent?) {
        guard let event = calendarEvent else { return }
        guard let localID = preparationID else { return }
        guard let name = preperationName else { return }

        permissionsManager.askPermission(for: [.calendar], completion: { [unowned self] status in
            guard let status = status[.calendar] else { return }

            switch status {
            case .granted:
                let eventStore = EKEventStore.shared
                guard let ekEvent = eventStore.event(with: event) else {
                    log("createPreparation - eventStore.save.error: event doesn't exist on calendar", level: .info)
                    // FIXME: create preparation link on the device which has EKEvent on it after synchronization.
                    // Need a flag for hasDeepLinkOnEKEvent : Bool
                    return
                }
                var notes = ekEvent.notes ?? ""
                guard let preparationLink = URLScheme.preparationURL(withID: localID) else { return }
                notes += "\n\n" + preparationLink
                log("preparationLink: \(preparationLink)")
                ekEvent.notes = notes
                do {
                    try eventStore.save(ekEvent, span: .thisEvent, commit: true)
                } catch let error {
                    log("createPreparation - eventStore.save.error: \(error.localizedDescription)", level: .error)
                    return
                }
            case .later:
                self.permissionsManager.updateAskStatus(.canAsk, for: .calendar)
                self.createPreparation(name: name, event: event)
            default:
                break
            }
        })
    }
}

// MARK: - Private

private extension PrepareCoordinator {

    func prepareChecklistViewModel(preparation: Preparation) -> PrepareContentViewModel? {
        var title: String? = nil
        var video: PrepareContentViewModel.Video? = nil
        var description: String?
        var items: [PrepareItem] = []

        title = preparation.subtitle
        for check in preparation.checks {
            guard let item = check.contentItem else { continue }
            let value = item.contentItemValue
            switch value {
            case .prepareStep(let title, _, _):
                items.append(PrepareItem(id: item.forcedRemoteID,
                                         title: item.contentCollection?.title ?? "",
                                         subTitle: title,
                                         readMoreID: item.contentCollection?.remoteID.value))
            case .video(_, _, let placeholderURL, let videoURL, _):
                video = PrepareContentViewModel.Video(url: videoURL, placeholderURL: placeholderURL)
            case .text(let text, let style):
                if style == .paragraph {
                    description = text
                }
            default:
                items.append(PrepareItem(id: item.forcedRemoteID,
                                         title: item.contentCollection?.title ?? "",
                                         subTitle: item.contentCollection?.description ?? "",
                                         readMoreID: item.relatedContent.first?.contentID))
            }
        }

        let preparationChecks = services.preparationService.preparationChecks(preparationID: preparationID)
        var checkedIDs: [Int: Date?] = [:]
        for preparationCheck in preparationChecks {
            checkedIDs[preparationCheck.contentItemID] = preparationCheck.covered
        }

        if let title = title {
            contentTitle = title
            let content = services.contentService.contentCollection(contentTitle: preparation.subtitle)
            let videoItem = content?.contentItems.filter { $0.format == "video" }.first
            description = videoItem?.valueDescription
            return PrepareContentViewModel(type: .prepContentEvent,
                                           title: title,
                                           video: video,
                                           description: description ?? "",
                                           items: items,
                                           checkedIDs: checkedIDs,
                                           preparationID: preparationID,
                                           contentCollectionTitle: preparation.subtitle,
                                           notes: preparation.notes,
                                           notesDictionary: preparation.notesDictionary,
                                           services: services)
        }
        return nil
    }
}

// MARK: - PrepareContentViewControllerDelegate

extension PrepareCoordinator: PrepareContentViewControllerDelegate {

    func didTapAddRemove(headerID: Int) {
        guard
            let prepareContentController = prepareListViewController,
            let preparation = services.preparationService.preparation(localID: preparationID) else { return }
        let checkedIDs = prepareContentController.viewModel.checkedIDs
        let relatedStrategies = services.contentService.relatedPrepareStrategies(self.contentTitle)
        let checks = services.preparationService.preparationChecks(preparationID: preparation.localID)
        let selectedIDs = Array(checks.compactMap { $0.contentItem?.contentCollection?.remoteID.value })
        let tempIDs = selectedIDs.filter { $0 != headerID }
        LaunchHandler().selectStrategies(relatedStrategies: relatedStrategies,
                                         selectedIDs: selectedIDs,
                                         prepareContentController: prepareContentController,
                                         completion: { (selectedContent, syncManager) in
                                            let tempIDsToCheck = selectedContent.compactMap { $0.contentCollectionID }
                                            if tempIDs.sorted() != tempIDsToCheck.sorted() {
                                                do {
                                                    try self.services.preparationService.updatePreparationChecks(preparationID: self.preparationID,
                                                                                                                 checkedIDs: checkedIDs,
                                                                                                                 selectedStrategies: selectedContent)
                                                } catch {
                                                    log("Error while updating preparationChecks: \(error)", level: .error)
                                                }
                                                let hud = MBProgressHUD.showAdded(to: prepareContentController.view, animated: true)
                                                syncManager.syncPreparations(shouldDownload: true, completion: { (error) in
                                                    if let viewModel = self.prepareChecklistViewModel(preparation: preparation) {
                                                        prepareContentController.updateViewModel(viewModel: viewModel)
                                                    }
                                                    hud.hide(animated: true)
                                                })
                                            }
        })
    }

    func saveNotes(notes: String, preparationID: String) {
        services.preparationService.saveNotes(notes, preparationID: preparationID)
        NotificationCenter.default.post(Notification(name: .startSyncPreparationRelatedData))
    }

    func didTapSavePreparation(in viewController: PrepareContentViewController) {
        showCreatePreparation(from: viewController, contentCollectionID: contentCollectionID)
    }

    func didTapClose(in viewController: PrepareContentViewController) {
        viewController.dismiss(animated: true, completion: nil)
        UIApplication.shared.setStatusBarStyle(.lightContent)
        chatDecisionManager.addQuestions()
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

        let coordinator = LearnContentItemCoordinator(root: viewController,
                                                      eventTracker: eventTracker,
                                                      services: services,
                                                      content: content,
                                                      category: category)
        startChild(child: coordinator)
    }

    private func showReadMoreError(viewController: UIViewController) {
        viewController.showAlert(type: .noContent)
    }
}

extension PrepareCoordinator: PrepareChatDecisionManagerDelegate {

    func setItems(_ items: [ChatItem<PrepareAnswer>], manager: PrepareChatDecisionManager) {
        chatViewController.viewModel.setItems(items)
    }

    func appendItems(_ items: [ChatItem<PrepareAnswer>], manager: PrepareChatDecisionManager) {
        chatViewController.viewModel.appendItems(items)
    }

    func showContent(id: Int, manager: PrepareChatDecisionManager, questionID: Int) {
        switch questionID {
        case 100006:
            showCreatePreparation(from: chatViewController, contentCollectionID: id)
        case 100008:
            showPrepareList(contentCollectionID: id)
        default:
            return
        }
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
        chatDecisionManager.addQuestions()
    }

    func didTapEvent(event: CalendarEvent, viewController: PrepareEventsViewController) {
        createPreparation(name: event.title, event: event) { (preparationID) in
            self.tabBarController.dismiss(animated: false)
            NotificationCenter.default.post(Notification(name: .startSyncPreparationRelatedData))
            if let id = preparationID {
                self.showPrepareCheckList(preparationID: id, chatDecisionManager: self.chatDecisionManager)
            }
        }
        widgetDataManager.update(.upcomingEvent)
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

    func eventEditViewController(_ controller: EKEventEditViewController,
                                 didCompleteWith action: EKEventEditViewAction) {
        handler?(controller, action)
    }
}

// MARK: - Create Preparation with Creating Event

extension PrepareCoordinator {

    func createPreparation(with ekEvent: EKEvent) {
        let event = CalendarEvent(event: ekEvent)
        var calendarSyncAvailable = true
        var dateInValidRange = true
        do {
            calendarSyncAvailable = try self.services.eventsService.calendarSyncEnabled(toggleIdentifier: event.calendarIdentifier,
                                                                                        title: event.title)
            // check out of date range. we collect always last 30 days and next 30 days
            let validStartDate = Date().dayBefore(days: 30)
            let validEndDate = Date().dayAfter(days: 30)

            if ekEvent.startDate < validStartDate || ekEvent.startDate > validEndDate {
                dateInValidRange = false
            }

            if calendarSyncAvailable == true && dateInValidRange == true {
                let realm = try self.services.realmProvider.realm()
                try realm.write {
                    realm.add(event)
                }
            } else { // If it's invalid, remove from calendar
                try EKEventStore.shared.remove(ekEvent, span: .futureEvents)
            }
        } catch {
            // Do nothing, any how the event exists on the device and will be synchronized next time.
        }
        if calendarSyncAvailable == true && dateInValidRange == true {
            do {
                let realm = try self.services.realmProvider.realm()
                if let createdEvent = realm.syncableObject(ofType: CalendarEvent.self, localID: event.localID) {
                    createEventWithCreatedCalendar(event: createdEvent, realm: realm)
                }
            } catch {
                //
            }
        } else {
            let alertType: AlertType = calendarSyncAvailable == false ? .calendarNotSynced : .eventDateNotAvailable
            self.tabBarController.dismiss(animated: true) {
                self.chatViewController.showAlert(type: alertType, handler: { [weak self] in
                    self?.chatDecisionManager.addQuestions()
                })
            }
        }
    }

    func createEventWithCreatedCalendar(event: CalendarEvent, realm: Realm) {
        self.createPreparation(name: event.title, event: event) { (preparationID) in
            self.tabBarController.dismiss(animated: true)
            let hud = MBProgressHUD.showAdded(to: self.tabBarController.view, animated: true)
            NotificationCenter.default.post(Notification(name: .startSyncPreparationRelatedData))
            if let id = preparationID {
                self.showPrepareCheckList(preparationID: id,
                                          chatDecisionManager: self.chatDecisionManager,
                                          progressHUD: hud)
                AppCoordinator.appState.syncManager.syncCalendarEvents { (error) in
                    if let createdPreparation = realm.syncableObject(ofType: Preparation.self, localID: id),
                        let createdEvent = realm.syncableObject(ofType: CalendarEvent.self, localID: event.localID) {
                        do {
                            try realm.transactionSafeWrite {
                                createdPreparation.calendarEventRemoteID.value = createdEvent.remoteID.value
                                createdPreparation.dirty = true
                            }
                        } catch {}
                    }
                }
            }
        }
    }
}

// MARK: - TopNavigationBarDelegate

extension PrepareCoordinator: NavigationItemDelegate {

    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {
        guard let pageViewController = topTabBarController.viewControllers.first as? PageViewController else { return }
        pageViewController.setPageIndex(index, animated: true)
        pageViewController.navigationItem.rightBarButtonItem = (index == 0 ? rightBarButtonItem : nil)
    }

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {
        AppDelegate.current.windowManager.showInfo(helpSection: .prepare)
    }

    func navigationItem(_ navigationItem: NavigationItem, searchButtonPressed button: UIBarButtonItem) {}
}
