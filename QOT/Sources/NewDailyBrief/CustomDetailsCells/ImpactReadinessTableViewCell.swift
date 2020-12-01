//
//  ImpactReadinessTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 24.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class ImpactReadinessTableViewCell: BaseDailyBriefCell {
    @IBOutlet weak var linkTitle: UILabel!
    @IBOutlet weak var ctaButton: AnimatedButton!

    weak var delegate: BaseDailyBriefDetailsViewControllerInterface?
    var feedbackRelatedLink: QDMAppLink?

    func configure(viewModel: ImpactReadinessCellViewModel?) {
        linkTitle.text = AppTextService.get(AppTextKey.daily_brief_section_my_best_suggestion_body)
        feedbackRelatedLink = viewModel?.feedbackRelatedLink
        ctaButton.setTitle(viewModel?.linkCTA, for: .normal)
        ThemeButton.newBlueButton.apply(ctaButton)
    }

    @IBAction func didTapCTAButton(_ sender: Any) {
        if let link = feedbackRelatedLink {
            trackUserEvent(.OPEN, value: link.appLinkId, stringValue: "DAILY_CHECK_IN_1", valueType: "APP_LINK", action: .TAP)
            link.launch()
        }
    }
}
