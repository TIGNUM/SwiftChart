//
//  AppCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import UserNotifications
import AirshipKit
import Buglife
import qot_dal

final class AppCoordinator {

    // MARK: - Static Properties

    static var permissionsManager: PermissionsManager?
    static var orientationManager: OrientationManager = OrientationManager()

    // MARK: - Properties

    private var isReadyToProcessURL = false

    private let remoteNotificationHandler: RemoteNotificationHandler
    private let locationManager: LocationManager
    private var canProcessRemoteNotifications = false
    private var canProcessLocalNotifications = false
    private var onDismiss: (() -> Void)?
    private weak var topTabBarController: UINavigationController?
    private weak var currentPresentedController: UIViewController?
    private weak var currentPresentedNavigationController: UINavigationController?
    lazy var userLogoutNotificationHandler = NotificationHandler(name: .userLogout)
    lazy var automaticLogoutNotificationHandler = NotificationHandler(name: .automaticLogout)
    lazy var apnsDeviceTokenRegistrator = APNSDeviceTokenRegistrator()
    private lazy var permissionsManager: PermissionsManager = {
        let manager = PermissionsManager(delegate: self)
        return manager
    }()

    // MARK: - Life Cycle

    init(remoteNotificationHandler: RemoteNotificationHandler,
         locationManager: LocationManager) {
        self.remoteNotificationHandler = remoteNotificationHandler
        self.locationManager = locationManager
        userLogoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }
        automaticLogoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFinishSynchronization(_:)),
                                               name: .didFinishSynchronization, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkDeletedEventForPreparation(_:)),
                                               name: .needToCheckDeletedEventForPreparation, object: nil)
    }

    func start(completion: @escaping (() -> Void)) {
        if let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController {
            if navigationController.viewControllers.first as? BaseRootViewController == nil {
                UIApplication.shared.delegate?.window??.rootViewController =
                    R.storyboard.bottomNavigation().instantiateInitialViewController()
            }
        } else {
            UIApplication.shared.delegate?.window??.rootViewController =
                R.storyboard.bottomNavigation().instantiateInitialViewController()
        }

        if Bundle.main.isFirstVersion == true {
            SessionService.main.logout()
        }
        UserDefault.lastInstaledAppVersion.setStringValue(value: Bundle.main.versionNumber)
        if UserDefault.firstInstallationTimestamp.object == nil {
            UserDefault.firstInstallationTimestamp.setObject(Date())
        }
        self.setupBugLife()

        if SessionService.main.getCurrentSession() != nil {
            self.showApp()
            completion()
        } else {
            UserDefault.clearAllDataLogOut()
            self.showSigning()
        }
        DispatchQueue.main.async {
            self.setupPermissionsManager()
        }
    }

    func setupPermissionsManager() {
        AppCoordinator.permissionsManager = self.permissionsManager
    }

    func restart() {
        logout()
        ExtensionsDataManager.didUserLogIn(false)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.showSigning()
        }
    }

    func setupBugLife() {
        guard SessionService.main.getCurrentSession() != nil else { return }
        if SessionService.main.getCurrentSession()?.useremail?.lowercased().contains("@tignum.com") == true {
            Buglife.shared().start(withAPIKey: "fj62sZjDnl3g0dLuXJHUzAtt") // FIXME: obfuscate
            Buglife.shared().delegate = AppDelegate.current
            Buglife.shared().invocationOptions = [.shake]
        } else {
            Buglife.shared().delegate = nil
            Buglife.shared().invocationOptions = [.init(rawValue: 0)]
        }
    }

    func checkVersionIfNeeded() {
        //guard services?.userService.user()?.appUpdatePrompt == true else { return }
        // TODO: We need to handle response from "/personal/p/qot/qotversionexpirydate"
    }

    func showApp(with displayedScreen: CoachCollectionViewController.Pages? = .dailyBrief) {
        ExtensionsDataManager.didUserLogIn(true)
        ExtensionsDataManager().update(.toBeVision)
        add3DTouchShortcuts()

        guard let coachCollectionViewController = R.storyboard.main.coachCollectionViewController(),
            let naviController = R.storyboard.bottomNavigation().instantiateInitialViewController() as? UINavigationController,
            let baseRootViewController = naviController.viewControllers.first as? BaseRootViewController else {
                return
        }

        self.setRootViewController(naviController,
                                   transitionStyle: .transitionCrossDissolve,
                                   duration: 0.7,
                                   animated: true) {
            DispatchQueue.main.async {
                // Show coach marks on first launch (of v3.0 app)
                let emails = UserDefault.didShowCoachMarks.object as? [String] ?? [String]()
                if let email = SessionService.main.getCurrentSession()?.useremail, !emails.contains(email) {
                    self.showTrackChoice()
                } else {
                    baseRootViewController.setContent(viewController: coachCollectionViewController)
                    self.isReadyToProcessURL = true
                }
            }
        }
    }

    private func setRootViewController(_ viewController: UIViewController, transitionStyle: UIViewAnimationOptions, duration: TimeInterval, animated: Bool, completion: (() -> Void)?) {
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window,
            let rootViewController = window.rootViewController else {
            assertionFailure("rootViewController should not be nil")
            return
        }
        window.makeKeyAndVisible()
        // FIXME: Setting the frame here is necessary to avoid an unintended animation in some situations.
        // Not sure why this is happening. We should investigate.
        viewController.view.frame = rootViewController.view.bounds
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window, duration: duration, options: transitionStyle, animations: {
            window.rootViewController = viewController
        }, completion: { _ in
            completion?()
        })
    }

    func isReadyToOpenURL() -> Bool {
        return isReadyToProcessURL
    }
}

// MARK: - private

private extension AppCoordinator {
    func showSubscriptionReminderIfNeeded() {
        UserService.main.getUserData({ [weak self] (userData) in
            let lastShownDate = UserDefault.subscriptionInfoShow.object as? Date
            if userData?.subscriptionExpired == true {
                // CHANGE ME
                self?.showSubscriptionReminder(isExpired: true)
            } else if userData?.subscriptionExpireSoon == true &&
                        (lastShownDate == nil || lastShownDate?.isToday == false) {
                UserDefault.subscriptionInfoShow.setObject(Date())
                // CHANGE ME
                self?.showSubscriptionReminder(isExpired: false)
            }
        })
    }

    func showSubscriptionReminder(isExpired: Bool) {
        let configurator = PaymentReminderConfigurator.make(isExpired: isExpired)
        let controller = PaymentReminderViewController(configure: configurator)
        let topViewController = AppDelegate.topViewController()
        topViewController?.present(controller, animated: false, completion: {

        })
    }
}

// MARK: - Navigation

extension AppCoordinator {
    func showTrackChoice() {
        guard let controller = R.storyboard.trackSelection.trackSelectionViewController(),
            let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController,
            let baseController = navigationController.viewControllers.first as? BaseRootViewController else { return }
        let configurator = TrackSelectionConfigurator.make()
        configurator(controller, .login)
        baseController.setContent(viewController: controller)
    }

    func showSigning() {
        let landingConfigurator = OnboardingLandingPageConfigurator.make()
        let landingController = OnboardingLandingPageViewController()
        landingConfigurator(landingController)

        let navigationController = UINavigationController(rootViewController: landingController)
        navigationController.navigationBar.isHidden = true
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overFullScreen
        guard let window = UIApplication.shared.delegate?.window else { return }
        window?.makeKeyAndVisible()
        window?.rootViewController?.present(navigationController, animated: false, completion: nil)
    }

    func logout() {
        permissionsManager.reset()
        setupBugLife()
        UserDefault.clearAllDataLogOut()
        isReadyToProcessURL = false
        environment.dynamicBaseURL = nil
        UserNotificationsManager.main.removeAll()
        UIApplication.shared.shortcutItems?.removeAll()
    }

    func didLogin() {
        showApp()
    }

    func add3DTouchShortcuts() {
        UIApplication.shared.shortcutItems = []
        let whatsHot = URLScheme.latestWhatsHotArticle
        UIApplication.shared.shortcutItems?.append(
            UIMutableApplicationShortcutItem(type: whatsHot.rawValue,
                                             localizedTitle: AppTextService.get(AppTextKey.generic_long_press_shortcut_title_wh_article),
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-whats-hot-article"),
                                             userInfo: ["link": whatsHot.launchPathWithParameterValue("")]))
        let tools = URLScheme.tools
        UIApplication.shared.shortcutItems?.append(
            UIMutableApplicationShortcutItem(type: tools.rawValue,
                                             localizedTitle: AppTextService.get(AppTextKey.generic_long_press_shortcut_title_tools),
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-tools"),
                                             userInfo: ["link": tools.launchPathWithParameterValue("")]))
        let myData = URLScheme.myData
        UIApplication.shared.shortcutItems?.append(
            UIMutableApplicationShortcutItem(type: myData.rawValue,
                                             localizedTitle: AppTextService.get(AppTextKey.generic_long_press_shortcut_title_review_my_data),
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-my-data"),
                                             userInfo: ["link": myData.launchPathWithParameterValue("")]))
    }
}

// MARK: - Handle incomming RemoteNotification

extension AppCoordinator {
    func handleIncommingNotificationDeepLinkURL(url: URL, completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let host = url.host, let scheme = URLScheme(rawValue: host) else {
            return
        }
        log("handleIncommingNotificationDeepLinkURL[\(scheme)]: \(url)", level: .info)
        // TODO: handle silent push notification... ie. Sync Content or import Calendar Events .. and so on
        completionHandler(.noData)
    }
}

// MARK: - PermissionDelegate

extension AppCoordinator: PermissionManagerDelegate {

    func permissionManager(_ manager: PermissionsManager,
                            didUpdatePermissions permissions: [PermissionsManager.Permission]) {
        manager.fetchDescriptions { (descriptions) in
            var devicePermissions = [QDMDevicePermission]()
            for permissionIdentifer in descriptions.keys {
                guard let statusString = descriptions[permissionIdentifer],
                    let status = QotDevicePermissionState(rawValue: statusString) else { continue }
                var devicePermission = QDMDevicePermission()
                devicePermission.permissionState = status
                switch permissionIdentifer {
                case .calendar:
                    devicePermission.feature = .calendar
                case .notifications:
                    devicePermission.feature = .notifcations
                case .location:
                    devicePermission.feature = .location
                case .photos:
                    devicePermission.feature = .photos
                case .camera:
                    devicePermission.feature = .camera
                }

                devicePermissions.append(devicePermission)
            }
            guard !devicePermissions.isEmpty else { return }
            QOTService.main.updateDevicePermissions(permissions: devicePermissions)
        }
    }
}

// MARK: Synchonization Update
extension AppCoordinator {

    @objc func didFinishSynchronization(_ notification: Notification) {
        let dataTypes: [SyncDataType] = [.CONTENT_COLLECTION, .DAILY_CHECK_IN_RESULT, .MY_TO_BE_VISION, .USER]
        guard let syncResult = notification.object as? SyncResultContext,
            dataTypes.contains(obj: syncResult.dataType) else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            switch syncResult.dataType {
            case .USER:
                guard syncResult.syncRequestType == .DOWN_SYNC else { break }
                self.handleUserDataDownSync()
            case .MY_TO_BE_VISION:
                guard syncResult.hasUpdatedContent else { return }
                self.handleMyToBeVisionDownSync()
            case .DAILY_CHECK_IN_RESULT:
                guard syncResult.hasUpdatedContent else { return }
                self.handleDailyCheckInResultDownSync()
            case .CONTENT_COLLECTION:
                guard syncResult.hasUpdatedContent else { return }
                self.handleContentDownSync()
            default: break
            }
        }
    }

    @objc func checkDeletedEventForPreparation(_ notification: Notification) {
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else { return }
        self.handlePreparationDownSync()
    }

    func handlePreparationDownSync() {
        let dispatchGroup = DispatchGroup()
        var didDownCalendarEvents = false
        dispatchGroup.enter()
        CalendarService.main.getCalendarEvents(from: Date(), { (_, initialized, _) in
            didDownCalendarEvents = initialized ?? false
            dispatchGroup.leave()
        })
        var preparations: [QDMUserPreparation]?
        dispatchGroup.enter()
        UserService.main.getUserPreparationsWithMissingEvent(from: Date().beginingOfDate(), { (preps, initalized, error) in
            preparations = preps
            dispatchGroup.leave()
        })

        dispatchGroup.notify(queue: .main, execute: {
            guard let preps = preparations, preps.count > 0, didDownCalendarEvents else { return }
            log("preps with missing events : \(preps)", level: .debug)
            let configurator = PreparationWithMissingEventConfigurator.make(preps)
            let viewController = PreparationWithMissingEventViewController.init(configure: configurator)
            baseRootViewController?.present(viewController, animated: true, completion: nil)
        })
    }

    func handleContentDownSync() {
        ContentService.main.getContentCollectionBySection(.WhatsHot, { (items) in
            guard let latest = items?.first else { return }
            let item = ArticleCollectionViewData.Item(author: latest.author ?? "",
                                                      title: latest.contentCategoryTitle ?? "",
                                                      description: latest.title,
                                                      date: latest.publishedDate ?? Date(),
                                                      duration: latest.durationString,
                                                      articleDate: latest.publishedDate ?? Date(),
                                                      sortOrder: "0",
                                                      previewImageURL: URL(string: latest.thumbnailURLString  ?? ""),
                                                      contentCollectionID: latest.remoteID ?? 0,
                                                      newArticle: true,
                                                      shareableLink: latest.shareableLink)
            ExtensionUserDefaults.set(ArticleCollectionViewData(items: [item]), for: .whatsHot)
        })
    }

    func handleDailyCheckInResultDownSync() {
        MyDataService.main.getDailyCheckInResults(from: Date().beginingOfDate(), to: nil, { (results, initiated, error) in
            guard error == nil, initiated == true, let result = results?.first else { return }

            let data = ExtensionModel.DailyPrep(loadValue: Float(result.load ?? 0),
                                                recoveryValue: Float(result.impactReadiness ?? 0),
                                                feedback: result.feedback, displayDate: Date())
            ExtensionUserDefaults.set(data, for: .dailyPrep)
        })
    }

    func handleMyToBeVisionDownSync() {
        UserService.main.getMyToBeVision({ (vision, initiated, error) in
            guard error == nil, initiated == true, let vision = vision else { return }
            let data = ExtensionModel.ToBeVision(headline: vision.headline, text: vision.text, imageURL: vision.profileImageResource?.url())
            ExtensionUserDefaults.set(data, for: .toBeVision)
        })
    }

    func handleUserDataDownSync() {
        UserService.main.getUserData({ (user) in
            guard var user = user else { return }
            if user.timeZone != TimeZone.hoursFromGMT {
                user.timeZone = TimeZone.hoursFromGMT
                UserService.main.updateUserData(user, { (_) in
                    /* */
                })
            }
        })
        showSubscriptionReminderIfNeeded()
    }
}
