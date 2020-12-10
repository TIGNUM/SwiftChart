//
//  FromTignumTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 10.12.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class FromTignumTableViewCell: BaseDailyBriefCell {
    @IBOutlet weak var ctaButton: RoundedButton!
    private var model: FromTignumCellViewModel?

    func configure(with model: FromTignumCellViewModel) {
        ctaButton.setTitle(model.cta, for: .normal)
        ThemeButton.whiteRounded.apply(ctaButton)
        self.model = model
    }

    @IBAction func didTapCTAButton(_ sender: Any) {
        model?.link?.launch()
    }
}
