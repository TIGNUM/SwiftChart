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
        let headerTitle = AppTextService.get(AppTextKey.coach_view_title_rule_your_compact)
        let headerSubtitle = AppTextService.get(AppTextKey.coach_view_title_your_next_step)
        let coachItems =  CoachSection.allCases.map {
            return CoachModel.Item(coachSections: $0,
                                   title: coachSectionTitles(for: $0),
                                   subtitle: coachSectionSubtitles(for: $0)) }
        return CoachModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, coachItems: coachItems)
    }

    func coachSectionTitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return AppTextService.get(AppTextKey.coach_view_title_search)
        case .tools:
            return AppTextService.get(AppTextKey.coach_view_title_apply_tools)
        case .sprint:
            return AppTextService.get(AppTextKey.coach_view_title_plan_sprint)
        case .event:
            return AppTextService.get(AppTextKey.coach_view_title_prepare_event)
        case .challenge:
            return AppTextService.get(AppTextKey.coach_view_title_solve_problem)
        }
    }

    func coachSectionSubtitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return AppTextService.get(AppTextKey.coach_view_title_what_youre_looking)
        case .tools:
            return AppTextService.get(AppTextKey.coach_view_title_access_tools)
        case .sprint:
            return AppTextService.get(AppTextKey.coach_view_title_run_5_day_sprint)
        case .event:
            return AppTextService.get(AppTextKey.coach_view_title_be_ready)
        case .challenge:
            return AppTextService.get(AppTextKey.coach_view_title_understand_your_struggle)
        }
    }
}
