//
//  TeamVisionSuggestionTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 07.12.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class TeamVisionSuggestionTableViewCell: BaseDailyBriefCell {
    @IBOutlet private weak var ctaButton: AnimatedButton!
    @IBOutlet private weak var suggestionBody: UILabel!
    var team: QDMTeam?
    weak var delegate: BaseDailyBriefDetailsViewControllerInterface?

    @IBAction func didTapCta(_ sender: Any) {
        guard let team = team else { return }
        delegate?.showTeamTBV(team)
    }

    func configure(with model: TeamVisionSuggestionModel?) {
        skeletonManager.hide()
        self.team = model?.team
        ThemeText.bodyText.apply(model?.adviceText, to: suggestionBody)
        ctaButton.setButtonContentInset(padding: 16)
        ctaButton.setTitle(AppTextService.get(.daily_brief_team_vision_suggestion_cta), for: .normal)
        ThemeButton.whiteRounded.apply(ctaButton)
    }
}
