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
    let tbvSentence: String?
    let adviceText: String?
    let team: QDMTeam?
    let imageURL: String?

    // MARK: - Init
    init(title: String?, team: QDMTeam?, tbvSentence: String?, adviceText: String?, imageURL: String?, domainModel: QDMDailyBriefBucket?) {
        self.tbvSentence = tbvSentence
        self.adviceText = adviceText
        self.team = team
        self.imageURL = imageURL
        super.init(domainModel,
                   caption: AppTextService.get(.daily_brief_vision_suggestion_caption).replacingOccurrences(of: "${team}", with: team?.name ?? ""),
                   title: AppTextService.get(.daily_brief_vision_suggestion_title),
                   body: tbvSentence,
                   image: imageURL,
                   titleColor: team?.teamColor)
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
