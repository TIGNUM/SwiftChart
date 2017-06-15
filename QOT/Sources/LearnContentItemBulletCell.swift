//
//  LearnContentItemBulletCell.swift
//  QOT
//
//  Created by karmic on 15.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnContentItemBulletCell: UITableViewCell, Dequeueable {

    @IBOutlet fileprivate weak var bulletLabel: UILabel!
    @IBOutlet fileprivate weak var bulletIndicatorLabel: UILabel!
    @IBOutlet fileprivate weak var bulletSeperatorView: UIView!

    func setupView(bulletText: String) {
        let attributedString = NSMutableAttributedString(
            string: bulletText,
            font: Font.DPText,
            lineSpacing: 14,
            textColor: .blackTwo
        )
        
        bulletLabel.attributedText = attributedString
        bulletIndicatorLabel.textColor = .blackTwo
        bulletSeperatorView.backgroundColor = .black30
    }
}
