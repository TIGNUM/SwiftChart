//
//  GuideTableViewCell.swift
//  QOT
//
//  Created by karmic on 05.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class GuideTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        statusView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        statusView.layer.masksToBounds = true
        containerView.backgroundColor = Color.Guide.cardBackground
    }

    func configure(title: String, content: String, type: String, status: GuideModel.Status) {
        titleLabel.attributedText = attributedText(letterSpacing: 1,
                                                   text: title.uppercased(),
                                                   font: Font.H4Identifier,
                                                   textColor: .white,
                                                   alignment: .left)
        contentLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                     text: content,
                                                     font: Font.H5SecondaryHeadline,
                                                     textColor: .white70,
                                                     alignment: .left)
        typeLabel.attributedText = attributedText(letterSpacing: 2,
                                                     text: type.uppercased(),
                                                     font: Font.H7Tag,
                                                     textColor: .white40,
                                                     alignment: .left)
        statusView.backgroundColor = status.color
    }

    private func attributedText(letterSpacing: CGFloat = 2, text: String, font: UIFont, textColor: UIColor, alignment: NSTextAlignment) -> NSMutableAttributedString {
        return NSMutableAttributedString(
            string: text,
            letterSpacing: letterSpacing,
            font: font,
            lineSpacing: 1.4,
            textColor: textColor,
            alignment: alignment,
            lineBreakMode: .byWordWrapping
        )
    }
}
