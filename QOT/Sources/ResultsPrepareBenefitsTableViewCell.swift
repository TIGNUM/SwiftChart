//
//  ResultsPrepareBenefitsTableViewCell.swift
//  QOT
//
//  Created by karmic on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareBenefitsTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var benefitsLabel: UILabel!

    func configure(title: String, subtitle: String, benefits: String) {
        ThemeText.H03Light.apply(title, to: titleLabel)
        ThemeText.H02Light.apply(subtitle, to: subtitleLabel)
        ThemeText.Text01Light.apply(benefits, to: benefitsLabel)
    }
}
