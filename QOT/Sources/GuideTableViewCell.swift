//
//  GuideTableViewCell.swift
//  QOT
//
//  Created by karmic on 05.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class GuideTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var actionLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.maskPathByRoundingCorners()
        actionLabel.font = .ApercuBold14
        typeLabel.adjustsFontSizeToFitWidth = true
        typeLabel.font = .ApercuRegular15
        typeLabel.textColor = .guideCardTypeGray
        titleLabel.font = .H4Identifier
        contentLabel.font = .H5SecondaryHeadline
        containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
    }

    // MARK: - Cell configuration

    func configure(title: String,
                   content: String,
                   type: String,
                   status: Guide.Item.Status,
                   strategiesCompleted: Int?) {
        contentLabel.text = content
        typeLabel.text = type.capitalized
        titleLabel.text = title.uppercased()
        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
		counterLabel.isHidden = strategiesCompleted == nil
		if let strategiesCompleted = strategiesCompleted {
			let text = R.string.localized.guideItemCompletedStrategiesCounter(strategiesCompleted,
                                                                              Defaults.totalNumberOfStrategies)
			let mutableAttributedText = attributedText(letterSpacing: 1.5,
													   text: text,
													   font: .H7Tag,
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
