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
    @IBOutlet weak var ctaButton: UIButton!
    weak var delegate: BaseDailyBriefDetailsViewControllerInterface?
    private var model: PeakPerformanceViewModel?

    func configure(with model: PeakPerformanceViewModel) {
        ThemeButton.newBlueButton.apply(ctaButton)
        ctaButton.setTitle(AppTextService.get(.daily_brief_section_my_peak_performances_button_title).uppercased(), for: .normal)
        self.model = model
    }

    @IBAction func didTapCTAButton(_ sender: Any) {
        delegate?.presentPrepareResults(for: model?.qdmUserPreparation)
    }
}
