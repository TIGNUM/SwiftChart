//
//  GuideHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 06.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class GuideHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var timingLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    func configure(message: String, timing: String) {
        messageLabel.attributedText = attributedText(letterSpacing: -0.8,
                                                   text: message.uppercased(),
                                                   font: Font.H4Headline,
                                                   textColor: .white,
                                                   alignment: .left)
        timingLabel.attributedText = attributedText(letterSpacing: 2,
                                                     text: timing.uppercased(),
                                                     font: Font.H7Tag,
                                                     textColor: .white40,
                                                     alignment: .left)
    }
}

// MARK: - Private

private extension GuideHeaderTableViewCell {

    func attributedText(letterSpacing: CGFloat = 2,
                        text: String,
                        font: UIFont,
                        textColor: UIColor,
                        alignment: NSTextAlignment) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         letterSpacing: letterSpacing,
                                         font: font,
                                         lineSpacing: 1.4,
                                         textColor: textColor,
                                         alignment: alignment,
                                         lineBreakMode: .byWordWrapping)
    }
}
