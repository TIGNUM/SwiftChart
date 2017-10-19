//
//  TrackablePage.swift
//  QOT
//
//  Created by Lee Arromba on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - TrackablePage

protocol TrackablePage: class {
    var pageName: PageName { get }
    var pageAssociatedObject: PageObject? { get }
}

extension TrackablePage {
    func associatedPage(realm: Realm) -> Page? {
        return realm.objects(Page.self).filter({ $0.name == self.pageName.rawValue }).first
    }
}

enum PageName: String {
    case addSensor = "sidebar.addsensor"
    case about = "sidebar.abouttignum"
    case benefits = "sidebar.benefits"
    case launch = "splashscreen"
    case learnCategoryList = "learn.strategies.categorylist"
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
    case myToBeVision = "me.mywhy.mytobevision"
    case myData = "me.mydata"
    case myWhy = "me.mywhy"
    case myPreparations = "prepare.mypreparations"
    case onboardingChat = "oboarding.chat"
    case prepareChat = "prepare.chat"
    case prepareCheckList = "prepare.preparationchecklist"
    case prepareContent = "prepare.preparationlist"
    case prepareEvents = "prepare.preparationlist.save"
    case privacy = "sidebar.dataprivacy"
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
    case sideBar = "sidebar"
    case sidebarLibrary = "sidebar.library"
    case tutorial = "tutorial"
    case weeklyChoices = "me.mywhy.weeklychoices"
    case whatsHot = "learn.whatshot.articlelist"
    case whatsHotArticle = "learn.whatshot.article"
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

extension AddSensorViewController: TrackablePage {
    var pageName: PageName {
        return .addSensor
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ArticleCollectionViewController: TrackablePage {
    // @see implementation
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ArticleItemViewController: TrackablePage {
    // @see implementation
    var pageAssociatedObject: PageObject? {
        return PageObject(object: viewModel.contentCollection, identifier: .contentCollection)
    }
}

//extension PageViewController: TrackablePage {
//    var pageName: PageName {
//        return .launchScreen
//    }
//    var pageAssociatedObject: PageObject? {
//        return nil
//    }
//}

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
        return .learnCategoryList
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
        let contentCollection = viewModel.item(at: IndexPath(row: selectedCategoryIndex, section: 0))
        return PageObject(object: contentCollection, identifier: .contentCollection)
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

extension LoadingViewController: TrackablePage {
    var pageName: PageName {
        return .loading
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension LoginViewController: TrackablePage {
    var pageName: PageName {
        return .login
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ResetPasswordViewController: TrackablePage {
    var pageName: PageName {
        return .resetPassword
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
        return .myPreparations
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ChartViewController: TrackablePage {
    var pageName: PageName {
        return .statistics
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension MyToBeVisionViewController: TrackablePage {
    var pageName: PageName {
        return .myToBeVision
    }
    var pageAssociatedObject: PageObject? {
        guard let myToBeVision = viewModel.item else {
            return nil
        }
        return PageObject(object: myToBeVision, identifier: .myToBeVision)
    }
}

extension MyUniverseViewController: TrackablePage {
    // @see implementation
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension PartnersViewController: TrackablePage {
    var pageName: PageName {
        return .myQOTPartners
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension ChatViewController: TrackablePage {
    //@see implementation
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension PrepareContentViewController: TrackablePage {
    //@see implementation
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
    var pageName: PageName {
        return .search
    }
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
        switch settingsType {
        case .general:
            return .settingsGeneral
        case .notifications:
            return .settingsNotifications
        case .security:
            return .settingsSecurity
        }
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension SettingsMenuViewController: TrackablePage {
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

extension TutorialViewController: TrackablePage {
    var pageName: PageName {
        return .tutorial
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
