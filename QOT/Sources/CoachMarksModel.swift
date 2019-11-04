//
//  CoachMarksModel.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct CoachMark {
    enum Step: Int, CaseIterable {
        case know = 0
        case myQot
        case coach
        case search

        var media: String {
            switch self {
            case .coach: return "walkThrough_coach"
            case .know: return "walkThrough_know"
            case .myQot: return "walkThrough_myQOT"
            case .search: return "walkThrough_search"
            }
        }

        var contentId: Int {
            switch self {
            case .coach: return 102527
            case .know: return 102525
            case .myQot: return 102526
            case .search: return 102528
            }
        }

        var rightButtonImage: UIImage? {
            if .search == self { return R.image.ic_getStarted_dark() }
            return R.image.ic_continue_dark()
        }

        var hideBackButton: Bool {
            return .know == self
        }

        var isLastPage: Bool {
            return .search == self
        }
    }

    struct ViewModel {
        let mediaName: String
        let title: String?
        let subtitle: String?
        let rightButtonImage: UIImage?
        let hideBackButton: Bool
        let page: Int
        let isLastPage: Bool
    }

    struct PresentationModel {
        let step: CoachMark.Step
        let content: QDMContentCollection?
    }
}
