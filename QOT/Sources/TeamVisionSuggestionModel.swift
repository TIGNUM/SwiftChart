//
//  TeamVisionSuggestionModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 31.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamVisionSuggestionModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    let title: String?
    let tbvSentence: String?
    let adviceText: String?
    let team: QDMTeam?

    // MARK: - Init
    init(title: String?, team: QDMTeam?, tbvSentence: String?, adviceText: String?, domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.tbvSentence = tbvSentence
        self.adviceText = adviceText
        self.team = team
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? TeamVisionSuggestionModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            adviceText == source.adviceText &&
            title == source.title &&
            tbvSentence == source.tbvSentence
    }
}
