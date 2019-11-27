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
        let headerTitle = AppTextService.get(AppTextKey.coach_section_header_title)
        let headerSubtitle = AppTextService.get(AppTextKey.coach_section_header_subtitle)
        let coachItems =  CoachSection.allCases.map {
            return CoachModel.Item(coachSections: $0,
                                   title: coachSectionTitles(for: $0),
                                   subtitle: coachSectionSubtitles(for: $0)) }
        return CoachModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, coachItems: coachItems)
    }

    func coachSectionTitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return AppTextService.get(AppTextKey.coach_section_search_title)
        case .tools:
            return AppTextService.get(AppTextKey.coach_section_tools_title)
        case .sprint:
            return AppTextService.get(AppTextKey.coach_section_sprint_title)
        case .event:
            return AppTextService.get(AppTextKey.coach_section_prepare_title)
        case .challenge:
            return AppTextService.get(AppTextKey.coach_section_solve_title)
        }
    }

    func coachSectionSubtitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return AppTextService.get(AppTextKey.coach_section_search_subtitle)
        case .tools:
            return AppTextService.get(AppTextKey.coach_section_tools_subtitle)
        case .sprint:
            return AppTextService.get(AppTextKey.coach_section_sprint_subtitle)
        case .event:
            return AppTextService.get(AppTextKey.coach_section_prepare_subtitle)
        case .challenge:
            return AppTextService.get(AppTextKey.coach_section_solve_subtitle)
        }
    }
}
