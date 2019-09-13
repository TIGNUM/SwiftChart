//
//  FatigueTableViewCell.swift
//  QOT
//
//  Created by karmic on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FatigueTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    @IBOutlet private weak var topTitleLabel: UILabel!
    @IBOutlet private weak var mainTitleLabel: UILabel!
    @IBOutlet private weak var fatigueLabel: UILabel!

    func configure(symptom: String) {
        selectionStyle = .none
        ThemeText.resultList.apply(R.string.localized.solveYourAnswers(), to: topTitleLabel)
        ThemeText.resultTitle.apply(R.string.localized.solveFatigue(), to: mainTitleLabel)
        ThemeText.resultHeader2.apply(symptom, to: fatigueLabel)
    }
}
