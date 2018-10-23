//
//  LearnContentItemBulletCell.swift
//  QOT
//
//  Created by karmic on 15.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnContentItemBulletCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var bulletLabel: UILabel!
    @IBOutlet private weak var bulletIndicatorLabel: UILabel!
    @IBOutlet private weak var bulletSeperatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }

    func setupView(bulletText: String) {
        bulletLabel.attributedText = NSMutableAttributedString(string: bulletText,
                                                               font: .DPText,
                                                               lineSpacing: 14,
                                                               textColor: .nightModeBlackTwo)
        bulletIndicatorLabel.textColor = .nightModeBlackTwo
        bulletSeperatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
}
