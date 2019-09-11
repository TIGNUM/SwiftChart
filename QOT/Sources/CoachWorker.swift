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
        let headerTitle = ScreenTitleService.main.coachHeaderTitle()
        let headerSubtitle = ScreenTitleService.main.coachHeaderSubtitle()
        let coachItems =  CoachSection.allCases.map {
            return CoachModel.Item(coachSections: $0,
                                   title: ScreenTitleService.main.coachSectionTitles(for: $0),
                                   subtitle: ScreenTitleService.main.coachSectionSubtitles(for: $0)) }
        return CoachModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, coachItems: coachItems)
    }

    func trackingKeys(at indexPath: IndexPath) -> String {
        guard let item = CoachSection.allCases.at(index: indexPath.row) else { return "UNKONW_COACH_TRACKING" }
        return item.trackingKeys()
    }
}
