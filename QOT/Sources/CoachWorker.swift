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

    private var user: QDMUser?
    private let dispatchGroup = DispatchGroup()

    init() {
    }

    // MARK: - Functions
    func coachSections(for user: QDMUser?) -> CoachModel {
        let headerTitle = AppTextService.get(.coach_section_header_title)
        let headerString = AppTextService.get(.coach_section_header_subtitle)
        let headerSubtitle = headerString.replacingOccurrences(of: "${username}", with: String(user?.givenName ?? ""))
        let coachItems =  CoachSection.allCases.map {
            return CoachModel.Item(coachSections: $0,
                                   title: coachSectionTitles(for: $0),
                                   subtitle: coachSectionSubtitles(for: $0))
        }
        return CoachModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, coachItems: coachItems)
    }

    func getData(_ completion: @escaping (_ coachModel: CoachModel) -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        UserService.main.getUserData { (user) in
            self.user = user
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(self.coachSections(for: self.user))
        }
    }

    func coachSectionTitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return AppTextService.get(.coach_section_search_title)
        case .tools:
            return AppTextService.get(.coach_section_tools_title)
        case .sprint:
            return AppTextService.get(.coach_section_sprint_title)
        case .event:
            return AppTextService.get(.coach_section_prepare_title)
        case .challenge:
            return AppTextService.get(.coach_section_solve_title)
        case .mindset:
            return AppTextService.get(.coach_section_mindset_title)
        case .recovery:
            return AppTextService.get(.coach_section_recovery_title)
        }
    }

    func coachSectionSubtitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return AppTextService.get(.coach_section_search_subtitle)
        case .tools:
            return AppTextService.get(.coach_section_tools_subtitle)
        case .sprint:
            return AppTextService.get(.coach_section_sprint_subtitle)
        case .event:
            return AppTextService.get(.coach_section_prepare_subtitle)
        case .challenge:
            return AppTextService.get(.coach_section_solve_subtitle)
        case .mindset:
            return AppTextService.get(.coach_section_mindset_subtitle)
        case .recovery:
            return AppTextService.get(.coach_section_recovery_subtitle)
        }
    }
}
