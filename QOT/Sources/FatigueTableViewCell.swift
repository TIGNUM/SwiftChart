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
        ThemeText.resultList.apply(AppTextService.get(AppTextKey.coach_tools_interactive_tool_3drecovery_result_section_your_answers_title_answers), to: topTitleLabel)
        ThemeText.resultTitle.apply(AppTextService.get(AppTextKey.coach_tools_interactive_tool_3drecovery_result_section_your_answers_title_fatigue), to: mainTitleLabel)
        ThemeText.resultHeader2.apply(symptom, to: fatigueLabel)
    }
}
