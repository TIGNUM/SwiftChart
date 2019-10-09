//
//  FatigueTableViewCell.swift
//  QOT
//
//  Created by karmic on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class FatigueTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    @IBOutlet private weak var topTitleLabel: UILabel!
    @IBOutlet private weak var mainTitleLabel: UILabel!
    @IBOutlet private weak var fatigueLabel: UILabel!

    func configure(symptom: String) {
        selectionStyle = .none
        ThemeText.resultList.apply(AppTextService.get(AppTextKey.coach_solve_results_view_answers_title), to: topTitleLabel)
        ThemeText.resultTitle.apply(AppTextService.get(AppTextKey.coach_solve_results_view_fatigue_title), to: mainTitleLabel)
        ThemeText.resultHeader2.apply(symptom, to: fatigueLabel)
    }
}
