//
//  TeamToBeVisionWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionWorker {

    // MARK: - Init
    init() { /**/ }

    private var teamVision: QDMTeamToBeVision?
    private var isMyVisionInitialized: Bool = false
    lazy var emptyTeamTBVTitlePlaceholder = AppTextService.get(.myx_team_tbv_header_title_headline)
    lazy var emptyTeamTBVTextPlaceholder = AppTextService.get(.myx_team_tbv_empty_subtitle_vision)
    lazy var teamNullStateSubtitle = AppTextService.get(.myx_team_tbv_null_state_subtitle)
    lazy var teamNullStateTitle = AppTextService.get(.myx_team_tbv_null_state_title)
    lazy var nullStateTeamCTA = AppTextService.get(.myx_team_tbv_null_state_cta)

    func getTeamToBeVision(for team: QDMTeam, _ completion: @escaping (_ initialized: Bool, _ toBeVision: QDMTeamToBeVision?) -> Void) {
        TeamService.main.getTeamToBevision(for: team, { [weak self] (teamVision, initialized, _) in
            self?.teamVision = teamVision
            self?.isMyVisionInitialized = initialized
            completion(initialized, teamVision)
        })
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }

    func updateTeamToBeVision(_ new: QDMTeamToBeVision, team: QDMTeam, completion: @escaping (_ toBeVision: QDMTeamToBeVision?) -> Void) {
        TeamService.main.updateTeamToBevision(vision: new) { [weak self] vision, error  in
            self?.getTeamToBeVision(for: team, { (_, qdmTeamVision) in
                //                 self.updateWidget() ?
                completion(qdmTeamVision)
            })
        }
    }

    func lastUpdatedTeamVision() -> String? {
        guard let date = teamVision?.date?.beginingOfDate() else { return nil }
        let days = DateComponentsFormatter.numberOfDays(date)
        return dateString(for: days)
    }

    private func dateString(for day: Int) -> String {
        if day == 0 {
            return "Today"
        } else if day == 1 {
            return "Yesterday"
        } else {
            return String(day) + " Days"
        }
    }
}
