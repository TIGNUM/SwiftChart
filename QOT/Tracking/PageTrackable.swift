//
//  TrackableView.swift
//  QOT
//
//  Created by Sam Wyndham on 13/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PageTrackable {
    var pageID: PageID { get }
}

extension LearnCategoryListViewController: PageTrackable {
    var pageID: PageID {
        return .learnCategoryList
    }
}

extension LearnContentListViewController: PageTrackable {
    var pageID: PageID {
        return .learnContentList
    }
}

extension MyUniverseViewController: PageTrackable {
    var pageID: PageID {
        return .meSection
    }
}

extension PrepareCheckListViewController: PageTrackable {
    var pageID: PageID {
        return .prepareCheckList
    }
}

extension ChatViewController: PageTrackable {
    var pageID: PageID {
        return .prepareChat
    }
}

extension PrepareContentViewController: PageTrackable {
    var pageID: PageID {
        return .prepareContent
    }
}

extension PrepareEventsViewController: PageTrackable {
    var pageID: PageID {
        return .prepareEvents
    }
}

extension SettingsViewController: PageTrackable {
    var pageID: PageID {
        return .settings
    }
}

extension SidebarViewController: PageTrackable {
    var pageID: PageID {
        return .sideBar
    }
}

extension TabBarController: PageTrackable {
    var pageID: PageID {
        return .tabBar
    }
}

extension LibraryViewController: PageTrackable {
    var pageID: PageID {
        return .sidebarLibrary
    }
}

extension BenefitsViewController: PageTrackable {
    var pageID: PageID {
        return .sidebarBenefits
    }
}
