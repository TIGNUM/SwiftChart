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

        var title: String {
            switch self {
            case .coach: return AppTextService.get(.onboarding_walkthrough_tools_title)
            case .know: return AppTextService.get(.onboarding_walkthrough_know_title)
            case .myQot: return AppTextService.get(.onboarding_walkthrough_myx_title)
            case .search: return AppTextService.get(.onboarding_walkthrough_search_title)
            }
        }

        var subtitle: String {
            switch self {
            case .coach: return AppTextService.get(.onboarding_walkthrough_coach_section_body_body)
            case .know: return AppTextService.get(.onboarding_walkthrough_know_section_body_body)
            case .myQot: return AppTextService.get(.onboarding_walkthrough_my_qot_section_body_body)
            case .search: return AppTextService.get(.onboarding_walkthrough_search_section_body_body)
            }
        }

        var rightButtonTitle: String? {
            if .search == self { return AppTextService.get(.onboarding_guided_track_section_footer_button_get_started)}
            return AppTextService.get(.my_qot_my_sprints_alert_button_continue)
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
        let rightButtonTitle: String?
        let hideBackButton: Bool
        let page: Int
        let isLastPage: Bool
    }

    struct PresentationModel {
        let step: CoachMark.Step
        let content: QDMContentCollection?
    }
}
