//
//  GuideDailyPrepTableViewCell.swift
//  QOT
//
//  Created by karmic on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class GuideDailyPrepTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var feedbackLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var valueContainerView: UIView!
    @IBOutlet private var valueViews: [UIView]!
    @IBOutlet private var valueLabels: [UILabel]!
    @IBOutlet private var valueTitleLabels: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()

        statusView.maskPathByRoundingCorners()
        containerView.corner(radius: 8)
        valueContainerView.backgroundColor = .clear
        valueViews.forEach { $0.backgroundColor = .clear }
        feedbackLabel.isHidden = true
        typeLabel.isHidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        valueViews.forEach { $0.isHidden = false }
        titleLabel.attributedText = nil
        typeLabel.attributedText = nil
        feedbackLabel.attributedText = nil
    }

    func configure(title: String?,
                   type: String?,
                   dailyPrepFeedback: String?,
                   dailyPrepItems: [Guide.DailyPrepItem],
                   status: Guide.Item.Status) {
        if let title = title {
            titleLabel.attributedText = attributedText(letterSpacing: 1,
                                                       text: title.uppercased(),
                                                       font: Font.H4Identifier,
                                                       textColor: .white,
                                                       alignment: .left)
        }

        if let type = type {
            typeLabel.isHidden = false
            typeLabel.attributedText = attributedText(letterSpacing: 2,
                                                      text: type.uppercased(),
                                                      font: Font.H7Tag,
                                                      textColor: .white40,
                                                      alignment: .left)
        }

        if let feedback = dailyPrepFeedback {
            feedbackLabel.isHidden = false
            feedbackLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                         text: feedback,
                                                         font: Font.DPText,
                                                         lineSpacing: 6,
                                                         textColor: .white70,
                                                         alignment: .left)
        }

        valueViews.filter { $0.tag > dailyPrepItems.count }.forEach { $0.isHidden = true }
        for (index, item) in dailyPrepItems.enumerated() {
            let resultText = item.result.map { String($0) } ?? "_"
            valueLabels[index].attributedText = attributedText(letterSpacing: -1.1,
                                                               text: resultText,
                                                               font: Font.H3Subtitle,
                                                               textColor: item.resultColor,
                                                               alignment: .left)

            valueTitleLabels[index].attributedText = attributedText(letterSpacing: 0.2,
                                                                    text: item.title,
                                                                    font: Font.H7Title,
                                                                    lineSpacing: 8,
                                                                    textColor: .white70,
                                                                    alignment: .left)
        }

        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
    }
}

// MARK: - Private

private extension GuideDailyPrepTableViewCell {

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
