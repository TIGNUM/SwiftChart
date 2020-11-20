//
//  MeAtMyBestTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 17.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class MeAtMyBestTableViewCell: BaseDailyBriefCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var ctaButton: UIButton!
    weak var delegate: BaseDailyBriefDetailsViewControllerInterface?

    @IBAction func didTapCTAButton(_ sender: Any) {
        delegate?.showTBV()
    }

    func configure(with viewModel: MeAtMyBestCellViewModel?) {
        guard let model = viewModel else {
            return
        }
        skeletonManager.hide()
        ThemeText.tbvStatement.apply(AppTextService.get(.daily_brief_section_my_best_suggestion_body), to: titleLabel)
        ThemeText.suggestionMyBest.apply(model.intro2, to: bodyLabel)
        ctaButton.setButtonContentInset(padding: 16)
        ctaButton.setTitle(model.buttonText?.uppercased(), for: .normal)
        ThemeButton.whiteRounded.apply(ctaButton)
    }

}
