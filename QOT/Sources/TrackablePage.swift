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
    case addSensor = "add_sensor"
    case articleItem = "article_item"
    case launch = "launch"
    case learnCategoryList = "learn_category_list"
    case learnContentItem = "learn_content_item"
    case learnContentList = "learn_content_list"
    case loading = "loading"
    case login = "login"
    case morningInterview = "morning_interview"
    case myQOTPartners = "qot_partners"
    case myStatistics = "my_statistics"
    case myToBeVision = "my_to_be_vision"
    case myUniverse = "my_universe"
    case prepareChat = "prepare_chat"
    case prepareCheckList = "preapre_check_list"
    case prepareContent = "prepare_content"
    case prepareEvents = "prepare_events"
    case resetPassword = "reset_password"
    case search = "search"
    case selectWeeklyChoices = "select_weekly_choices"
    case settings = "settings"
    case settingsCalendarList = "settings_calendar_list"
    case settingsChangePassword = "settings_change_password"
    case settingsMenu = "settings_menu"
    case sideBar = "sidebar"
    case sidebarLibrary = "sidebar_library"
    case tutorial = "tutorial"
    case weeklyChoices = "weekly_choices"
    case whatsHot = "whats_hot"
}

struct PageObject {
    let object: SyncableObject
    let identifier: String
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
}

extension ArticleItemViewController: TrackablePage {
    var pageName: PageName {
        return .articleItem
    }
    var pageAssociatedObject: PageObject? {
        return nil
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
        return nil
    }
}

extension LearnContentItemViewController: TrackablePage {
    var pageName: PageName {
        return .learnContentItem
    }
    var pageAssociatedObject: PageObject? {
        return PageObject(object: viewModel.contentCollection, identifier: "CONTENTCOLLECTION")
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
        return .prepareCheckList
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension MyStatisticsViewController: TrackablePage {
    var pageName: PageName {
        return .myStatistics
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
        return nil
    }
}

extension MyUniverseViewController: TrackablePage {
    var pageName: PageName {
        return .myUniverse
    }
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
    var pageName: PageName {
        return .prepareChat
    }
    var pageAssociatedObject: PageObject? {
        return nil
    }
}

extension PrepareContentViewController: TrackablePage {
    var pageName: PageName {
        return .prepareContent
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
        return .settings
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
