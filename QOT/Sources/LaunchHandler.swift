//
//  LaunchHandler.swift
//  QOT
//
//  Created by Moucheg Mouradian on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import SVProgressHUD
import qot_dal
import HealthKit

enum LaunchOption: String {
    case edit
}

final class LaunchHandler {

    private var appDelegate: AppDelegate {
        return AppDelegate.current
    }

    func canLaunch(url: URL) -> Bool {
        return URLScheme.isSupportedURL(url)
    }

    func process(url: URL) {
        guard let host = url.host,
            let scheme = URLScheme(rawValue: host) else {
            processExternal(url: url)
            return
        }

        guard appDelegate.appCoordinator.isReadyToOpenURL(),
            SessionService.main.getCurrentSession() != nil else {
                RestartHelper.setRestartURL(url)
                return
        }
        RestartHelper.clearRestartRouteInfo()

        if AppCoordinator.permissionsManager == nil {
            appDelegate.appCoordinator.setupPermissionsManager()
        }

        var queries: [String: String?] = [:]
        for queryItem in url.queryItems() {
            queries[queryItem.name] = queryItem.value
        }

        switch scheme {
        case .dailyBrief,
             .guide:
            showFirstLevelScreen(page: .dailyBrief, queries[scheme.queryNames.first ?? ""] ?? nil)

        case .dailyCheckIn,
             .dailyPrep:

            showDailyCheckIn()
        case .latestWhatsHotArticle:

            ContentService.main.getContentCollectionBySection(.WhatsHot, { [weak self] (items) in
                guard let contentId = items?.first?.remoteID else { return }
                self?.showContentCollection(contentId)
            })

        case .ouraring: NotificationCenter.default.post(name: .requestOpenUrl, object: url)
        case .content_item,
             .contentItem:
            guard let itemIdString = queries[scheme.queryNames.first ?? ""] ?? nil, let itemId = Int(itemIdString) else { break }
            showContentItem(itemId)
        case .knowFeed,
             .strategies: showFirstLevelScreen(page: .know)
        case .myQOT,
             .meQotPartner,
             .meTravel: showFirstLevelScreen(page: .myX)
        case .coachMode: presentCoachModeScreen()
        case .createSolveAChallenge,
             .prepareProblem:
            let configurator = DTSolveConfigurator.make()
            let controller = DTSolveViewController(configure: configurator)
            controller.triggeredByLaunchHandler = true
            present(viewController: controller)
        case .planASprint:
            let configurator = DTSprintConfigurator.make()
            let controller = DTSprintViewController(configure: configurator)
            controller.triggeredByLaunchHandler = true
            present(viewController: controller)
        case .tools,
             .library:
            guard let controller = R.storyboard.tools.toolsViewControllerID() else { return }
            ToolsConfigurator.make(viewController: controller)
            present(viewController: controller)
        case .prepareEvent,
             .prepareDay:
            let configurator = DTPrepareStartConfigurator.make()
            let controller = DTPrepareStartViewController(configure: configurator)
            controller.triggeredByLaunchHandler = true
            baseRootViewController?.presentRightToLeft(controller: controller)
        case .preparation:
            showPreparationWith(identifier: (queries[scheme.queryNames.first ?? ""] as? String) ?? "" )
        case .myPreparations,
             .myPreps,
             .comingEvent,
             .prepare:
            guard let controller = R.storyboard.myPreps.myPrepsViewControllerID() else { return }
            MyPrepsConfigurator.configure(viewController: controller, delegate: nil)
            push(viewController: controller)
        case .myData,
             .weeklyPeakPerformance,
             .meMyWhy,
             .meChoices,
             .meActivity,
             .meIntensity,
             .meMeeting,
             .meSleep,
             .meUniverse,
             .mePeakPerformance:
            guard let controller = R.storyboard.myDataScreen.myDataScreenViewControllerID() else { return }
            let configurator = MyDataScreenConfigurator.make()
            configurator(controller)
            push(viewController: controller)
        case .toBeVision:
            if let controller = R.storyboard.myToBeVision.myVisionViewController() {
                MyVisionConfigurator.configure(viewController: controller)
                push(viewController: controller)
            }
        case .mySprints:
            guard let controller = R.storyboard.mySprints.mySprintsListViewController() else { return }
            let configurator = MySprintsListConfigurator.make()
            configurator(controller)
            push(viewController: controller)
        case .myLibrary:
            showMyLibrary(queries)
        case .myProfile:
            guard let controller = R.storyboard.myQot.myQotProfileID() else { return }
            MyQotProfileConfigurator.configure(delegate: nil, viewController: controller)
            push(viewController: controller)
        case .syncedCalendars,
             .preferencesSyncCalendar:
            guard let controller = R.storyboard.myQot.syncedCalendarsViewController() else { return }
            SyncedCalendarsConfigurator.configure(viewController: controller)
            push(viewController: controller)
        case .accountSetting,
             .profile:
            guard let controller = R.storyboard.myQot.myQotAccountSettingsViewController() else { return }
             MyQotAccountSettingsConfigurator.configure(viewController: controller)
             push(viewController: controller)
        case .appSettings,
             .preferencesNotification:
            guard let controller = R.storyboard.myQot.myQotAppSettingsViewController() else { return }
             MyQotAppSettingsConfigurator.configure(viewController: controller)
             push(viewController: controller)
        case .activityTrackers,
             .addSensor,
             .fitbitApp:
            guard let controller = R.storyboard.myQot.myQotSensorsViewController() else { return }
             MyQotSensorsConfigurator.configure(viewController: controller)
             push(viewController: controller)
        case .support:
            guard let controller = R.storyboard.myQot.myQotSupportViewController() else { return }
            MyQotSupportConfigurator.configure(viewController: controller)
            push(viewController: controller)
        case .faq:
            guard let controller = R.storyboard.myQot.myQotSupportDetailsViewController() else { return }
            MyQotSupportDetailsConfigurator.configure(viewController: controller, category: .FAQ)
            push(viewController: controller)
        case .usingQOT,
             .usingTIGNUMX,
             .tutorial:
            guard let controller = R.storyboard.myQot.myQotSupportDetailsViewController() else { return }
            MyQotSupportDetailsConfigurator.configure(viewController: controller, category: .UsingQOT)
            push(viewController: controller)
        case .aboutTignum:
            guard let controller = R.storyboard.myQot.myQotAboutUsViewController() else { return }
            MyQotAboutUsConfigurator.configure(viewController: controller)
            push(viewController: controller)
        case .siriShortCuts,
             .siriSettings:
            guard let controller = R.storyboard.myQot.myQotSiriShortcutsViewController() else { return }
            MyQotSiriShortcutsConfigurator.configure(viewController: controller)
            push(viewController: controller)
        case .qotBenefits: showContentCollection(MyQotAboutUsModel.Item.benefits.primaryKey)
        case .aboutTignumDetail: showContentCollection(MyQotAboutUsModel.Item.about.primaryKey)
        case .privacy: showContentCollection(MyQotAboutUsModel.Item.privacy.primaryKey)
        case .termsAndConditions: showContentCollection(MyQotAboutUsModel.Item.terms.primaryKey)
        case .contentCopyrights: showContentCollection(MyQotAboutUsModel.Item.copyright.primaryKey)
        case .performanceFoundation: showLearnStrategy(nil)
        case .performanceHabituation: showLearnStrategy(.PerformanceHabituation)
        case .performanceRecovery: showLearnStrategy(.PerformanceRecovery)
        case .performanceNutrition: showLearnStrategy(.PerformanceNutrition)
        case .performanceMovement: showLearnStrategy(.PerformanceMovement)
        case .performanceMindset: showLearnStrategy(.PerformanceMindset)
        case .contentCategory:
            guard let categoryIdString = queries.first?.value, let categoryId = Int(categoryIdString) else { break }
            showCategory(categoryId)
        case .randomContent,
             .featureExplainer:
            guard let contentIdString = queries[scheme.queryNames.first ?? ""] ?? nil,
                let contentId = Int(contentIdString) else { break }
            showContentCollection(contentId)
        case .qrcode0001, .qrcode0002, .qrcode0003, .qrcode0004, .qrcode0005, .qrcode0006, .qrcode0007, .qrcode0008,
             .qrcode0009, .qrcode0010:
            presentQRCodeURL(url)
        case .recovery3DPlanner: show3DRecoveryDecisionTree()
        case .mindsetShifterPlanner: showMindsetShifterDecisionTree()
        case .teamInvitations: showPendingInvitations()
        case .tbvTrackerPollClosed:
            guard let teamIdString = queries.first?.value, let teamId = Int(teamIdString) else { break }
            showTeamTBVTrends(teamId)
        case .tbvGeneratorPollClosed:
            guard let teamIdString = queries.first?.value, let teamId = Int(teamIdString) else { break }
            showTeamTBV(teamId)
        case .tbvGeneratorPollOpened:
            guard let teamIdString = queries.first?.value, let teamId = Int(teamIdString) else { break }
            showTBVPoll(teamId)
        case .tbvTrackerPollOpened:
            guard let teamIdString = queries.first?.value, let teamId = Int(teamIdString) else { break }
            showTBVRating(teamId)
        default: break
        }
        NotificationCenter.default.post(name: .stopAudio, object: nil)
    }

    func presentQRCodeURL(_ url: URL) {
        guard let settingKey = SettingKey(rawValue: url.absoluteString) else {
            return
        }
        SettingService.main.getSettingFor(key: settingKey) { (setting, _, error) in
            guard let setting = setting, error == nil,
                let urlString = setting.textValue,
                let targetURL = URL(string: urlString) else {
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.open(targetURL, options: [:], completionHandler: nil)
            }
        }
    }

    func processExternal(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }
    }
}

// MARK: - Show Screen

extension LaunchHandler {

    func showPendingInvitations() {
        let identifier = R.storyboard.team.teamInviteViewControllerID.identifier
        let controller = R.storyboard.team().instantiateViewController(withIdentifier: identifier) as? TeamInvitesViewController
        TeamService.main.getTeamInvitations { (invitations, error) in
            guard error == nil else { return }
            let teamItem = Team.Item(invites: invitations ?? [])
            if let controller = controller {
                let configurator = TeamInvitesConfigurator.make(teamItems: [teamItem])
                configurator(controller)
                self.push(viewController: controller)
            }
        }
    }

    func showTeamTBVTrends(_ teamId: Int) {
        getTeam(teamId) { (team) in
            if let controller = R.storyboard.myToBeVisionRate.myToBeVisionTrackerViewController() {
                TBVRateHistoryConfigurator.configure(viewController: controller,
                                                     displayType: .tracker,
                                                     team: team)
                AppDelegate.topViewController()?.present(controller, animated: true)
            }
        }
    }

    func showTeamTBV(_ teamId: Int) {
        getTeam(teamId) { (team) in
            if let team = team {
                if let controller = R.storyboard.myToBeVision.teamToBeVisionViewController() {
                    let configurator = TeamToBeVisionConfigurator.make(team: team)
                    configurator(controller)
                    AppDelegate.topViewController()?.show(controller, sender: nil)
                }
            }
        }
    }

    func showTBVRating(_ teamId: Int) {
        getTeam(teamId) { (team) in
            if let team = team {
                if let controller = R.storyboard.visionRatingExplanation.visionRatingExplanationViewController() {
                    VisionRatingExplanationConfigurator.make(team: team, type: .ratingUser)(controller)
                    AppDelegate.topViewController()?.present(controller, animated: true)
                }
            }
        }
    }

    func showTBVPoll(_ teamId: Int) {
        getTeam(teamId) { (team) in
            if let team = team {
                if let controller = R.storyboard.visionRatingExplanation.visionRatingExplanationViewController() {
                    VisionRatingExplanationConfigurator.make(team: team, type: .tbvPollUser)(controller)
                    AppDelegate.topViewController()?.present(controller, animated: true)
                }
            }
        }
    }

    func getTeam(_ teamId: Int, _ completion: @escaping (QDMTeam?) -> Void) {
        TeamService.main.getTeams { (teams, _, _) in
            if let teams = teams, teams.isEmpty == false {
                if let team = teams.filter({ $0.remoteID == teamId }).first {
                    completion(team)
                }
            } else {
                completion(nil)
            }
        }
    }

    func showFirstLevelScreen(page: CoachCollectionViewController.Page,
                              _ bucketName: String? = nil,
                              _ knowingSection: Knowing.Section? = nil) {
        guard let mainNavi = baseRootViewController?.navigationController else {
            return
        }
        mainNavi.popToRootViewController(animated: true)
        mainNavi.dismissAllPresentedViewControllers(mainNavi, true) {
            NotificationCenter.default.post(name: .showFirstLevelScreen, object: page)
        }

        if let section = knowingSection {
            NotificationCenter.default.post(name: .showKnowingSection, object: section)
        }

        if let bucket = bucketName {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) + .microseconds(500)) {
                NotificationCenter.default.post(name: .scrollToBucket, object: bucket)
            }
        }
    }

    func showDailyCheckIn() {
        MyDataService.main.getDailyCheckInResults(from: Date.beginingOfDay(), to: nil) { [weak self] (results, initialized, error) in
            guard initialized == true, error == nil else {
                return // DO NOTHING
            }
            if results?.first != nil {
                self?.showFirstLevelScreen(page: .dailyBrief, DailyBriefBucketName.DAILY_CHECK_IN_1)
            } else {
                guard let viewController = R.storyboard.dailyCheckin.dailyCheckinQuestionsViewController() else { return }
                DailyCheckinQuestionsConfigurator.configure(viewController: viewController)
                let topViewController = AppDelegate.topViewController()
                if (topViewController as? DailyCheckinQuestionsViewController) != nil {
                    topViewController?.dismiss(animated: false, completion: {
                        self?.present(viewController: viewController)
                    })
                } else {
                    self?.present(viewController: viewController)
                }

            }
        }
    }

    func showContentItem(_ itemId: Int) {
        ContentService.main.getContentItemById(itemId) { (contentItem) in
            guard let contentItem = contentItem else { return }
            switch contentItem.format {
            case .pdf:
                guard let pdfURL = URL(string: contentItem.valueMediaURL ?? "") else {
                    return
                }
                baseRootViewController?.showPDFReader(withURL: pdfURL, title: contentItem.valueText, itemID: itemId)
            case .audio:
                guard let mediaURL = URL(string: contentItem.valueMediaURL ?? "") else { return }
                let media = MediaPlayerModel(title: contentItem.valueText,
                                             subtitle: "",
                                             url: mediaURL,
                                             totalDuration: Double(contentItem.valueDuration ?? 0),
                                             progress: 0,
                                             currentTime: 0,
                                             mediaRemoteId: contentItem.remoteID ?? 0)
                NotificationCenter.default.post(name: .playPauseAudio, object: media)
            case .video:
                guard let mediaURL = URL(string: contentItem.valueMediaURL ?? "") else { return }
                baseRootViewController?.stream(videoURL: mediaURL, contentItem: contentItem)
            default: break
            }
        }
    }

    func showContentCollection(_ collectionId: Int) {
        ContentService.main.getContentCollectionById(collectionId, { [weak self] (content) in
            guard let contentCollection = content else { return }
            if contentCollection.contentItems.count == 1,
                (contentCollection.section == .LearnStrategies ||
                    contentCollection.section == .Tools ||
                    contentCollection.section == .QOTLibrary),
                let contentItemId = contentCollection.contentItems.first?.remoteID {
                self?.showContentItem(contentItemId)
                return
            }

            switch contentCollection.section {
            case .Tools, .QOTLibrary:
                if let controller = R.storyboard.tools.tignum_XToolsItemsViewController() {
                    ToolsItemsConfigurator.make(viewController: controller, selectedToolID: collectionId)
                    self?.present(viewController: controller)
                }
            default:
                if let controller = R.storyboard.main.tignum_XArticleViewController() {
                    ArticleConfigurator.configure(selectedID: collectionId, viewController: controller)
                    if let detailsVC = AppDelegate.topViewController() as? BaseDailyBriefDetailsViewController {
                        controller.modalPresentationStyle = .overFullScreen
                        detailsVC.present(controller, animated: true, completion: nil)
                    } else {
                        self?.present(viewController: controller)
                    }
                }
            }
        })
    }

    func presentCoachModeScreen() {
        guard let mainNavi = baseRootViewController?.navigationController else {
            return
        }
        guard let coachViewController = R.storyboard.coach.coachViewControllerID() else {
            return
        }
        CoachConfigurator.make(viewController: coachViewController)
        let coachScreenNavigationController = UINavigationController(rootViewController: coachViewController)
        coachScreenNavigationController.modalTransitionStyle = .coverVertical
        coachScreenNavigationController.isNavigationBarHidden = true
        coachScreenNavigationController.isToolbarHidden = true
        coachScreenNavigationController.view.backgroundColor = .clear
        mainNavi.dismissAllPresentedViewControllers(mainNavi, true) {
            self.present(viewController: coachScreenNavigationController)
        }
    }

    func showPreparationWith(identifier: String) {
        UserService.main.getUserPreparationWith(qotId: identifier) { (preparation, initialized, _) in
            if let qdmUserPreparation = preparation {
                let configurator = ResultsPrepareConfigurator.make(qdmUserPreparation, resultType: .prepareDailyBrief)
                let controller = ResultsPrepareViewController(configure: configurator)
                self.present(viewController: controller)
            }
        }
    }

    func showMindsetShifterDecisionTree() {
        guard let mainNavigationController = baseRootViewController?.navigationController else { return }
        mainNavigationController.dismissAllPresentedViewControllers(mainNavigationController, true) {
            let configurator = DTMindsetConfigurator.make()
            let controller = DTMindsetViewController(configure: configurator)
            controller.triggeredByLaunchHandler = true
            self.present(viewController: controller)
            baseRootViewController?.removeBottomNavigation()
        }
    }

    func show3DRecoveryDecisionTree() {
        guard let mainNavigationController = baseRootViewController?.navigationController else { return }
        mainNavigationController.dismissAllPresentedViewControllers(mainNavigationController, true) {
            let configurator = DTRecoveryConfigurator.make()
            let controller = DTRecoveryViewController(configure: configurator)
            controller.triggeredByLaunchHandler = true
            self.present(viewController: controller)
            baseRootViewController?.removeBottomNavigation()
        }
    }

    func showMyLibrary(_ queries: [String: String?]) {
        guard let controller = R.storyboard.myLibrary.myLibraryCategoryListViewController() else { return }
        let dispatchGroup = DispatchGroup()
        let category = queries["category"] ?? nil
        var team: QDMTeam?
        dispatchGroup.enter()
        if let teamIdString = queries["teamId"] as? String, let teamId = Int(teamIdString) {
            dispatchGroup.enter()
            TeamService.main.getTeams { (teams, _, _) in
                team = teams?.filter({ $0.remoteID == teamId }).first
                dispatchGroup.leave()
            }
        }
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) {
            let configurator = MyLibraryCategoryListConfigurator.make(with: team, category)
            configurator(controller)
            self.push(viewController: controller)
        }
    }

    func dismissChatBotFlow() {
        if baseRootViewController?.QOTVisibleViewController() is CoachViewController {
            baseRootViewController?.QOTVisibleViewController()?.dismiss(animated: true)
        } else {
            baseRootViewController?.dismiss(animated: true)
        }
    }

    func showLearnStrategy(_ category: ContentCategory?) {
        showCategory(category?.rawValue)
    }

    func showCategory(_ categoryId: Int?) {
        if let controller = R.storyboard.main.tignum_XStrategyListViewController() {
            StrategyListConfigurator.configure(viewController: controller, selectedStrategyID: categoryId)
            push(viewController: controller)
        }
    }

    func push(viewController: UIViewController) {
        baseRootViewController?.pushToStart(childViewController: viewController, enableInteractivePop: true)
    }

    func present(viewController: UIViewController) {
        baseRootViewController?.present(viewController, animated: true, completion: nil)
    }
}

// MARK: - HEALTH DATA ACCESS PERMISSION
extension LaunchHandler {
    func requestHealthKitAuthorization(_ completion: @escaping (Bool) -> Void) {
        HealthService.main.requestHealthKitAuthorization { (success, error) in
            if let error = error {
                log("Error requestHealthKitAuthorization: \(error.localizedDescription)", level: .error)
            }
            completion(success)
        }
    }

    func getHealthKitAuthStatus() -> HKAuthorizationStatus {
        return HealthService.main.healthKitAuthorizationStatus()
    }

    func importHealthKitData() {
        if HealthService.main.isHealthDataAvailable() == true {
            HealthService.main.importHealthKitSleepAnalysisData()
        }
    }
}
