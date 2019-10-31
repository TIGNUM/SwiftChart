//
//  CoachMarksModel.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct CoachMark {
    enum Step: Int, CaseIterable {
        case know = 0
        case myQot
        case coach
        case search

        var media: String {
            switch self {
            case .coach: return "walkThorugh_coach"
            case .know: return "walkThorugh_know"
            case .myQot: return "walkThorugh_myQOT"
            case .search: return "walkThorugh_search"
            }
        }

        var title: String {
            switch self {
            case .coach: return "COACH MODE"
            case .know: return "KNOW"
            case .myQot: return "MY QOT"
            case .search: return "SEARCH"
            }
        }

        var subtitle: String {
            switch self {
            case .coach: return "Tap the Q button to find solutions for your day-to-day challenges."
            case .know: return "Swipe right to access strategies and curated content."
            case .myQot: return "Swipe left to access your personal library and your impact rediness data."
            case .search: return "Swipe down to easily access the search funtion."
            }
        }

        var rightButtonImage: UIImage? {
            if .search == self { return R.image.ic_getStarted_dark() }
            return R.image.ic_continue_dark()
        }

        var hideBackButton: Bool {
            return .know == self
        }
    }

    struct ViewModel {
        let mediaName: String
        let title: String
        let subtitle: String
        let rightButtonImage: UIImage?
        let hideBackButton: Bool
        let page: Int
    }
}
