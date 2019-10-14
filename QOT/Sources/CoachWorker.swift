//
//  CoachWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CoachWorker {

    // MARK: - Init

    init() {
    }

    // MARK: - Functions

    func coachSections() -> CoachModel {
        let headerTitle = AppTextService.get(AppTextKey.coach_view_rule_your_compact_title)
        let headerSubtitle = AppTextService.get(AppTextKey.coach_view_your_next_step_title)
        let coachItems =  CoachSection.allCases.map {
            return CoachModel.Item(coachSections: $0,
                                   title: coachSectionTitles(for: $0),
                                   subtitle: coachSectionSubtitles(for: $0)) }
        return CoachModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, coachItems: coachItems)
    }


    func coachSectionTitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return AppTextService.get(AppTextKey.coach_view_search_title)
        case .tools:
            return AppTextService.get(AppTextKey.coach_view_apply_tools_title)
        case .sprint:
            return AppTextService.get(AppTextKey.coach_view_plan_sprint_title)
        case .event:
            return AppTextService.get(AppTextKey.coach_view_prepare_event_title)
        case .challenge:
            return AppTextService.get(AppTextKey.coach_view_solve_problem_title)
        }
    }

    func coachSectionSubtitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return AppTextService.get(AppTextKey.coach_view_what_youre_looking_title)
        case .tools:
            return AppTextService.get(AppTextKey.coach_view_access_tools_title)
        case .sprint:
            return AppTextService.get(AppTextKey.coach_view_run_5_day_sprint_title)
        case .event:
            return AppTextService.get(AppTextKey.coach_view_be_ready_title)
        case .challenge:
            return AppTextService.get(AppTextKey.coach_view_understand_your_struggle_title)
        }
    }
}
