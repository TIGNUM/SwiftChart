//
//  MeAtMyBestTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 17.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

class MeAtMyBestTableViewCell: BaseDailyBriefCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var ctaButton: UIButton!
    weak var delegate: BaseDailyBriefDetailsViewControllerInterface?

    @IBAction func didTapCTAButton(_ sender: Any) {
        delegate?.showCustomizeTarget()
    }
}
