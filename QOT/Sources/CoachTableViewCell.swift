//
//  CoachTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Lifecycle

    func configure(title: String, subtitle: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                               letterSpacing: 0.4,
                                                               font: .apercuMedium(ofSize: 20),
                                                               textColor: UIColor.accent,
                                                               alignment: .left)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                       letterSpacing: 0.2,
                                                       font: .apercuLight(ofSize: 12),
                                                       lineSpacing: 4,
                                                       textColor: UIColor.carbon,
                                                       alignment: .left)
    }
}
