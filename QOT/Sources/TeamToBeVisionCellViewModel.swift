//
//  TeamToBeVisionCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 30.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamToBeVisionCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var teamVision: String?
    var title: String?

    // MARK: - Init
    init(title: String?, teamVision: String?, domainModel: QDMDailyBriefBucket?) {
        self.teamVision = teamVision
        self.title = title
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? TeamToBeVisionCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            teamVision == source.teamVision &&
            title == source.title
    }
}
