//
//  PeakPerformanceTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 23.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class PeakPerformanceTableViewCell: BaseDailyBriefCell {
    @IBOutlet weak var ctaButton: RoundedButton!
    weak var delegate: BaseDailyBriefDetailsViewControllerInterface?
    private var model: PeakPerformanceViewModel?

    func configure(with model: PeakPerformanceViewModel) {
        let buttonTitle = AppTextService.get(.daily_brief_section_my_peak_performances_button_title).uppercased()
        if !buttonTitle.isEmpty {
            ctaButton.setTitle(buttonTitle, for: .normal)
        }
        ThemeButton.newBlueButton.apply(ctaButton)
        ThemableButton.newBlueButton.apply(ctaButton, title: buttonTitle)
        self.model = model
    }

    @IBAction func didTapCTAButton(_ sender: Any) {
        delegate?.presentPrepareResults(for: model?.qdmUserPreparation)
    }
}
