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

extension LaunchViewController: PageTrackable {
    var pageID: PageID {
        return .launch
    }
}

extension MainMenuViewController: PageTrackable {
    var pageID: PageID {
        return .mainMenu
    }
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
