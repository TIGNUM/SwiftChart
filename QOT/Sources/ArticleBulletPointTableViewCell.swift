//
//  ArticleBulletPointTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleBulletPointTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var bulletLabel: UILabel!

    func configure(bullet: String) {
        bulletLabel.attributedText = NSAttributedString(string: bullet,
                                                       letterSpacing: 0.5,
                                                       font: .apercuLight(ofSize: 16),
                                                       lineSpacing: 8,
                                                       textColor: colorMode.textColor.withAlphaComponent(0.6),
                                                       alignment: .left)
    }
}
