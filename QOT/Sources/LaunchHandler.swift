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
        guard let host = url.host, let scheme = URLScheme(rawValue: host) else {
            processExternal(url: url)
            return
        }

        guard appDelegate.appCoordinator.isReadyToOpenURL(),
            qot_dal.SessionService.main.getCurrentSession() != nil else {
                RestartHelper.setRestartURL(url)
                return
        }
        RestartHelper.clearRestartRouteInfo()

        if AppCoordinator.permissionsManager == nil {
            appDelegate.appCoordinator.setupPermissionsManager()
        }

        var queries: [String: String?] = [:]
        for queryItem in url.queryItems() {
            queries[scheme.queryName] = queryItem.value
        }

        switch scheme {
        case .dailyBrief,
             .guide: showFirstLevelScreen(page: .dailyBrief, queries[scheme.queryName] ?? nil)
        case .dailyCheckIn,
             .dailyPrep: showDailyCheckIn()
        case .latestWhatsHotArticle:
            qot_dal.ContentService.main.getContentCollectionBySection(.WhatsHot, { [weak self] (items) in
                guard let contentId = items?.first?.remoteID else { return }
                self?.showContentCollection(contentId)
            })
        case .ouraring: NotificationCenter.default.post(name: .requestOpenUrl, object: url)
        case .content_item,
             .contentItem:
            guard let itemIdString = queries[scheme.queryName] ?? nil, let itemId = Int(itemIdString) else { break }
            showContentItem(itemId)
        case .knowFeed,
             .strategies: showFirstLevelScreen(page: .know)
        case .myQOT,
             .meQotPartner,
             .meTravel: showFirstLevelScreen(page: .myQot)
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
            let configurator = DTPrepareConfigurator.make()
            let controller = DTPrepareViewController(configure: configurator)
            controller.triggeredByLaunchHandler = true
            present(viewController: controller)
        case .preparation:
            showPreparationWith(identifier: (queries[scheme.queryName] as? String) ?? "" )
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
            let identifier = R.storyboard.myToBeVision.myVisionViewController.identifier
            guard let controller = R.storyboard.myToBeVision()
                .instantiateViewController(withIdentifier: identifier) as? MyVisionViewController else { return }
            MyVisionConfigurator.configure(viewController: controller)
            push(viewController: controller)
        case .mySprints:
            guard let controller = R.storyboard.mySprints.mySprintsListViewController() else { return }
            let configurator = MySprintsListConfigurator.make()
            configurator(controller)
            push(viewController: controller)
        case .myLibrary:
            guard let controller = R.storyboard.myLibrary.myLibraryCategoryListViewController() else { return }
            let configurator = MyLibraryCategoryListConfigurator.make()
            configurator(controller)
            push(viewController: controller)
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
        case .qotBenefits: showContentCollection(MyQotAboutUsModel.MyQotAboutUsModelItem.benefits.primaryKey)
        case .aboutTignumDetail: showContentCollection(MyQotAboutUsModel.MyQotAboutUsModelItem.about.primaryKey)
        case .privacy: showContentCollection(MyQotAboutUsModel.MyQotAboutUsModelItem.privacy.primaryKey)
        case .termsAndConditions: showContentCollection(MyQotAboutUsModel.MyQotAboutUsModelItem.terms.primaryKey)
        case .contentCopyrights: showContentCollection(MyQotAboutUsModel.MyQotAboutUsModelItem.copyright.primaryKey)
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
            guard let contentIdString = queries[scheme.queryName] ?? nil, let contentId = Int(contentIdString) else { break }
            showContentCollection(contentId)
        case .qrcode0001,
             .qrcode0002,
             .qrcode0003,
             .qrcode0004: presentQRCodeURL(url)
        case .recovery3DPlanner: show3DRecoveryDecisionTree()
        case .mindsetShifterPlanner: showMindsetShifterDecisionTree()
        default: break
        }
        NotificationCenter.default.post(name: .stopAudio, object: nil)
        qot_dal.NotificationService.main.reportVisitedNotificationLink(url.absoluteString) { (_) in /* WOW */}
    }

    func presentQRCodeURL(_ url: URL) {
        guard let settingKey = SettingKey(rawValue: url.absoluteString) else {
            return
        }
        qot_dal.SettingService.main.getSettingFor(key: settingKey) { (setting, _, error) in
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
        guard let scheme = url.scheme else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }

        guard let schemeEnum = URLScheme(rawValue: scheme) else { return }
        guard let alternative = URL(string: schemeEnum.alternativeURLString) else { return }
        UIApplication.shared.open(alternative, options: [:], completionHandler: nil)
    }
}

// MARK: - Preparation

extension LaunchHandler {

    func preparation(localID: String?) {
//        guard let localID = localID else { return }
        // FIXME: Show preparation detail
    }
}

// MARK: - Show Screen

extension LaunchHandler {

    func showFirstLevelScreen(page: CoachCollectionViewController.Pages,
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
        qot_dal.MyDataService.main.getDailyCheckInResults(from: Date.beginingOfDay(), to: nil) { [weak self] (results, initialized, error) in
            guard initialized == true, error == nil else {
                return // DO NOTHING
            }
            if results?.first != nil {
                self?.showFirstLevelScreen(page: .dailyBrief, DailyBriefBucketName.DAILY_CHECK_IN_1)
            } else {
                guard let viewController = R.storyboard.dailyCheckin.dailyCheckinQuestionsViewController() else { return }
                DailyCheckinQuestionsConfigurator.configure(viewController: viewController)
                self?.present(viewController: viewController)
            }
        }
    }

    func showContentItem(_ itemId: Int) {
        //        guard let localID = localID else { return }
        // FIXME: Show preparation detail
        qot_dal.ContentService.main.getContentItemById(itemId) { (contentItem) in
            guard let contentItem = contentItem else { return }
            switch contentItem.format {
            case .pdf:
                guard let pdfURL = URL(string: contentItem.valueMediaURL ?? "") else {
                    return
                }
                baseRootViewController?.showPDFReader(withURL: pdfURL, title: contentItem.valueText, itemID: itemId)
            case .audio,
                 .video:
                guard let mediaURL = URL(string: contentItem.valueMediaURL ?? "") else { return }
                baseRootViewController?.stream(videoURL: mediaURL, contentItem: contentItem)
            default: break
            }
        }
    }

    func showContentCollection(_ collectionId: Int) {
        qot_dal.ContentService.main.getContentCollectionById(collectionId, { [weak self] (content) in
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
            case .LearnStrategies, .WhatsHot, .ExclusiveRecoveryContent:
                if let controller = R.storyboard.main.qotArticleViewController() {
                    ArticleConfigurator.configure(selectedID: collectionId, viewController: controller)
                    self?.present(viewController: controller)
                }
            case .Tools, .QOTLibrary:
                if let controller = R.storyboard.tools().instantiateViewController(withIdentifier: R.storyboard.tools.qotToolsItemsViewController.identifier) as? ToolsItemsViewController {
                    ToolsItemsConfigurator.make(viewController: controller, selectedToolID: collectionId)
                    self?.present(viewController: controller)
                }
            default: break
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
                let configurator = PrepareResultsConfigurator.make(qdmUserPreparation, resultType: .prepareDailyBrief)
                let controller = PrepareResultsViewController(configure: configurator)
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

    func dismissChatBotFlow() {
        baseRootViewController?.QOTVisibleViewController()?.dismiss(animated: true, completion: nil)
    }

    func showLearnStrategy(_ category: qot_dal.ContentCategory?) {
        showCategory(category?.rawValue)
    }

    func showCategory(_ categoryId: Int?) {
        if let controller = R.storyboard.main.qotStrategyListViewController() {
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
