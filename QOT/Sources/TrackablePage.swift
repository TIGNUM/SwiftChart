//
//  TrackablePage.swift
//  QOT
//
//  Created by Lee Arromba on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import MessageUI
import AVKit

// MARK: - TrackablePage

protocol TrackablePage: class {
    var pageName: PageName { get }
    var pageAssociatedObject: PageObject? { get }
}

extension TrackablePage {
    func associatedPage(realm: Realm) -> Page? {
        let name = self.pageName.rawValue
        return realm.objects(Page.self).filter("name == %@", name).first
    }
}

enum PageName: String {
    case addSensor = "sidebar.addsensor"
    case about = "sidebar.abouttignum"
    case benefits = "sidebar.benefits"
    case faq = "sidebar.faq"
    case featureExplainer = "guide.tools.feature.explainer"
    case launch = "splashscreen"
    case learnContentItemFull = "learn.strategies.strategy.full"
    case learnContentItemBullet = "learn.strategies.strategy.bullet"
    case learnContentItemAudio = "learn.strategies.strategy.audio"
    case learnContentList = "learn.strategies.strategylist"
    case libraryArticle = "sidebar.library.article"
    case loading = "loading"
    case login = "login"
    case morningInterview = "notification.dailyprep"
    case myQOTPartners = "me.mywhy.qotpartners"
    case statistics = "me.mydata.charts"
    case myData = "me.mydata"
    case myWhy = "me.mywhy"
    case myPreparations = "prepare.mypreparations"
    case myPreparationsNotes = "prepare.mypreparations.prepare.mypreparations.noteList"
    case onboardingChat = "onboarding.chat"
    case prepareChat = "prepare.chat"
    case prepareCheckList = "prepare.preparationchecklist"
    case prepareContent = "prepare.preparationlist"
    case prepareEvents = "prepare.preparationlist.save"
    case privacy = "sidebar.dataprivacy"
    case terms = "sidebar.termsAndConditions"
    case copyrights = "sidebar.copyrights"
    case resetPassword = "resetpassword"
    case search = "search"
    case selectWeeklyChoices = "notification.weeklychoices"
    case settings = "sidebar.settings"
    case settingsCalendarList = "sidebar.settings.calendar.list"
    case settingsChangePassword = "sidebar.settings.security.changepassword"
    case settingsMenu = "sidebar.settings.menu"
    case settingsGeneral = "sidebar.settings.general"
    case settingsNotifications = "sidebar.settings.notifications"
    case settingsSecurity = "sidebar.settings.security"
    case settingsPermissions = "settings.permissions"
    case settingsSiriShortCuts = "settings.siriShortCuts"
    case settingsSiriShortCutsTBV = "settings.siriShortCuts.tbv"
    case settingsSiriShortCutsEvents = "settings.siriShortCuts.events"
    case settingsSiriShortCutsDPMFeedback = "settings.siriShortCuts.dpmFeedback"
    case settingsSiriShortCutsWhatsHot = "settings.siriShortCuts.whatsHot"
    case sideBar = "sidebar"
    case sideBarSearch = "sidebar.search"
    case sidebarLibrary = "sidebar.library"
    case sidebarSupport = "sidebar.support"
    case tabBarItemGuide = "tabBarItem.guide"
    case tabBarItemLearn = "tabBarItem.learn"
    case tabBarItemToBeVision = "tabBarItem.toBeVision"
    case tabBarItemData = "tabBarItem.data"
    case tabBarItemPrepare = "tabBarItem.prepare"
    case tabBarItemGuideSearch = "tabBarItem.guide.tabBarItem.guide.search"
    case tutorial = "tutorial"
    case visionGenerator = "tabBarItem.toBeVision.generator"
    case weeklyChoices = "me.mywhy.weeklychoices"
    case whatsHot = "learn.whatshot.articlelist"
    case whatsHotArticle = "learn.whatshot.article"
    case infoDailyPrep = "info.dailyprep"
    case infoToBeVision = "info.tobevision"
    case infoPrepare = "info.prepare"
    case infoGuide = "info.guide"
    case infoLearn = "tutorial.info.learn"
    case infoToBeVisionGuide = "info.tobevision.guide"
    case infoData = "tutorial.info.data"
    case supportContact = "support.contact"
    case featureRequest = "support.featurerequest"
    case imagePickerProfile = "imagepicker.profile"
    case imagePickerToBeVision = "imagepicker.vision"
    case imagePickerGenerator = "imagepicker.generator"
    case imagePickerPartner = "imagepicker.partners"
    case shareToBeVision = "share.tobevision"
    case chartInfoIntensityPerceivedLoad = "chart.info.intensity.PerceivedLoad"
    case chartInfoIntensityPerceivedRecovery = "chart.info.intensity.PerceivedRecovery"
    case chartInfoMeetingsNumber = "chart.info.meetings.number"
    case chartInfoMeetingsTimeBetween = "chart.info.meetings.timeBetween"
    case chartInfoMeetingsTimeIn = "chart.info.meetings.timeIn"
    case chartInfoMeetingsIncreaseDiff = "chart.info.meetings.increaseDiff"
    case chartInfoSleepQuality = "chart.info.sleep.quality"
    case chartInfoSleepQuantity = "chart.info.sleep.quantity"
    case chartInfoActivityMovement = "chart.info.activity.movement"
    case chartInfoActivityLevel = "chart.info.activity.level"
    case prepareNotesIntentionsPreceived = "prepare.notes.intensions.perceived"
    case prepareNotesIntentionsFeel = "prepare.notes.intensions.feel"
    case prepareNotesIntentionsKnow = "prepare.notes.intensions.know"
    case prepareNotesReflectionGood = "prepare.notes.reflection.good"
    case prepareNotesReflectionNotGood = "prepare.notes.reflection.notGood"
    case prepareNotesGeneral = "prepare.notes.general"
}

struct PageObject {
    enum Identifier: String {
        case myToBeVision = "MYTOBEVISION"
        case category = "CONTENTCATEGORY"
        case contentCollection = "CONTENT"
        case contentItem = "CONTENTITEM"
        case preparation = "PREPARATION"
    }

    let object: SyncableObject
    let identifier: Identifier
}

// MARK: - extensions

extension SensorViewController: TrackablePage {
    var pageName: PageName {
        return .addSensor
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension GuideViewController: TrackablePage {
    var pageAssociatedObject: PageObject? {
         return nil
    }

    var pageName: PageName {
        return .tabBarItemGuide
    }
}

extension ArticleCollectionViewController: TrackablePage {
    var pageName: PageName {
        return ArticleCollectionViewController.pageName
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ArticleItemViewController: TrackablePage {
    var pageName: PageName {
        return ArticleItemViewController.page
    }
    // @see implementation
    var pageAssociatedObject: PageObject? {
        return PageObject(object: viewModel.contentCollection, identifier: .contentCollection)
    }
}

extension AnimatedLaunchScreenViewController: TrackablePage {
    var pageName: PageName {
        return .launch
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension LearnCategoryListViewController: TrackablePage {
    var pageName: PageName {
        return .tabBarItemLearn
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension LearnContentListViewController: TrackablePage {
    var pageName: PageName {
        return .learnContentList
    }
    var pageAssociatedObject: PageObject? {
        let category = viewModel.category(at: selectedCategoryIndex)
        return PageObject(object: category, identifier: .category)
    }
}

extension LearnContentItemViewController: TrackablePage {
    var pageName: PageName {
        switch tabType {
        case .full:
            return .learnContentItemFull
        case .bullets:
            return .learnContentItemBullet
        case .audio:
            return .learnContentItemAudio
        }
    }
    var pageAssociatedObject: PageObject? {
        return PageObject(object: viewModel.contentCollection, identifier: .contentCollection)
    }
}

extension LibraryViewController: TrackablePage {
    var pageName: PageName {
        return .sidebarLibrary
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SigningLoginViewController: TrackablePage {
    var pageName: PageName {
        return .login
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension MorningInterviewViewController: TrackablePage {
    var pageName: PageName {
        return .morningInterview
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension MyPrepViewController: TrackablePage {
    var pageName: PageName {
        return MyPrepViewController.page
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ChartViewController: TrackablePage {
    var pageName: PageName {
        if let infoPageName = infoPageName {
            return infoPageName
        }
        return .tabBarItemData
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension MyToBeVisionViewController: TrackablePage {
    var pageName: PageName {
        return MyToBeVisionViewController.page
    }
    var pageAssociatedObject: PageObject? {
        return interactor?.trackablePageObject
    }
}

extension MyUniverseViewController: TrackablePage {
    // @see implementation
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension PartnersOverviewViewController: TrackablePage {
    var pageName: PageName {
        return .myQOTPartners
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ChatViewController: TrackablePage {
    var pageName: PageName {
        return page
    }
    //@see implementation
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension PrepareContentViewController: TrackablePage {
    var pageName: PageName {
        return PrepareContentViewController.pageName
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension PrepareEventsViewController: TrackablePage {
    var pageName: PageName {
        return .prepareEvents
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SearchViewController: TrackablePage {
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SelectWeeklyChoicesViewController: TrackablePage {
    var pageName: PageName {
        return .selectWeeklyChoices
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SettingsViewController: TrackablePage {
    var pageName: PageName {
        return .settings
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension PermissionsViewController: TrackablePage {
    var pageName: PageName {
        return .settingsPermissions
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SiriShortcutsViewController: TrackablePage {
    var pageName: PageName {
        if let shortcutPageName = selectedShortCutPage {
            return shortcutPageName
        }
        return .settingsSiriShortCuts
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SettingsBubblesViewController: TrackablePage {
    var pageName: PageName {
        switch settingsType {
        case .about: return .about
        case .support: return .sidebarSupport
        }
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension OldSettingsViewController: TrackablePage {
    var pageName: PageName {
        switch settingsType {
        case .general:
            return .settingsGeneral
        case .notifications:
            return .settingsNotifications
        case .security:
            return .settingsSecurity
        case .profile:
            return .settingsGeneral
        case .settings:
            return .settingsGeneral
        }
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ProfileSettingsViewController: TrackablePage {
    var pageName: PageName {
        return .settingsMenu
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SettingsCalendarListViewController: TrackablePage {
    var pageName: PageName {
        return .settingsCalendarList
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SettingsChangePasswordViewController: TrackablePage {
    var pageName: PageName {
        return .settingsChangePassword
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SidebarViewController: TrackablePage {
    var pageName: PageName {
        return .sideBar
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension WeeklyChoicesViewController: TrackablePage {
    var pageName: PageName {
        return .weeklyChoices
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension TutorialViewController: TrackablePage {
    var pageName: PageName {
        return .tutorial
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ScreenHelpViewController: TrackablePage {
    var pageName: PageName {
        switch category {
        case .toBeVision: return .infoToBeVision
        case .dailyPrep: return .infoDailyPrep
        case .learn: return .infoLearn
        case .guide: return .infoGuide
        case .prepare: return .infoPrepare
        case .toBeVisionGuide: return .infoToBeVisionGuide
        case .data: return .infoData
        }
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SupportFAQViewController: TrackablePage {
    var pageName: PageName {
        return .faq
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension MFMailComposeViewController: TrackablePage {
    var pageName: PageName {
        switch pageType {
        case .supportContact:
            return .supportContact
        case .featureRequest:
            return .featureRequest
        case .shareToBeVision:
            return .shareToBeVision
        default: return .supportContact
        }
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ImagePickerController: TrackablePage {
    var pageName: PageName {
        switch page {
        case .imagePickerToBeVision:
            return .imagePickerToBeVision
        case .imagePickerProfile:
            return .imagePickerProfile
        case .imagePickerGenerator:
            return .imagePickerGenerator
        case .imagePickerPartner:
            return .imagePickerPartner
        default: return .imagePickerToBeVision
        }
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension PrepareNotesViewController: TrackablePage {
    var pageName: PageName {
        return selectedNotes.pageName
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension AVPlayerViewController: TrackablePage {
    var pageName: PageName {
        return pageType
    }
    var pageAssociatedObject: PageObject? {
        guard let contentItem = contentItem else { return nil }
        return PageObject(object: contentItem, identifier: .contentItem)
    }
}
