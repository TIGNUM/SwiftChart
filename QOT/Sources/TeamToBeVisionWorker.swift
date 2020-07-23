//
//  TeamToBeVisionWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionWorker: WorkerTeam {

    // MARK: - Init
    init() { /**/ }

    lazy var emptyTeamTBVTitlePlaceholder = AppTextService.get(.myx_team_tbv_header_title_headline)
    lazy var emptyTeamTBVTextPlaceholder = AppTextService.get(.myx_team_tbv_empty_subtitle_vision)
    lazy var teamNullStateSubtitle = AppTextService.get(.myx_team_tbv_null_state_subtitle)
    lazy var teamNullStateTitle = AppTextService.get(.myx_team_tbv_null_state_title)
    lazy var nullStateTeamCTA = AppTextService.get(.myx_team_tbv_null_state_cta)

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }
}
