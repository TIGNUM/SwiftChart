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
    @IBOutlet private weak var counterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.maskPathByRoundingCorners()
        containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
        typeLabel.adjustsFontSizeToFitWidth = true
    }

    func configure(title: String,
                   content: String,
                   type: String,
                   status: Guide.Item.Status,
                   strategiesCompleted: Int?) {
        titleLabel.attributedText = attributedText(letterSpacing: 1,
                                                   text: title.uppercased(),
                                                   font: Font.H5SecondaryHeadline,
                                                   textColor: .white,
                                                   alignment: .left)
        contentLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                     text: content,
                                                     font: Font.DPText,
                                                     lineSpacing: 6,
                                                     textColor: .white70,
                                                     alignment: .left)
        typeLabel.attributedText = attributedText(letterSpacing: 2,
                                                  text: type.uppercased(),
                                                  font: Font.H7Tag,
                                                  textColor: .white40,
                                                  alignment: .left)
        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
		counterLabel.isHidden = strategiesCompleted == nil
		if let strategiesCompleted = strategiesCompleted {
			let text = R.string.localized.guideItemCompletedStrategiesCounter(strategiesCompleted,
                                                                              Defaults.totalNumberOfStrategies)
			let mutableAttributedText = attributedText(letterSpacing: 1.5,
													   text: text,
													   font: Font.H7Tag,
													   textColor: .white40,
													   alignment: .right)
			mutableAttributedText.addAttribute(.foregroundColor,
											   value: UIColor.white,
											   range: NSRange(location: 0, length: 2))
			counterLabel.attributedText = mutableAttributedText
		}
    }
}

// MARK: - Private

private extension GuideTableViewCell {

    func attributedText(letterSpacing: CGFloat = 2,
                        text: String,
                        font: UIFont,
                        lineSpacing: CGFloat = 1.4,
                        textColor: UIColor,
                        alignment: NSTextAlignment) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         letterSpacing: letterSpacing,
                                         font: font,
                                         lineSpacing: lineSpacing,
                                         textColor: textColor,
                                         alignment: alignment,
                                         lineBreakMode: .byWordWrapping)
    }
}
