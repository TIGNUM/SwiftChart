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

        valueViews.forEach {
            $0.isHidden = false
        }
        titleLabel.attributedText = nil
        typeLabel.attributedText = nil
        feedbackLabel.attributedText = nil
    }

    func configure(title: String?, type: String?, dailyPrep: Guide.Item.DailyPrep?, status: GuideViewModel.Status) {
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

        if let feedback = dailyPrep?.feedback {
            feedbackLabel.isHidden = false
            feedbackLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                         text: feedback,
                                                         font: Font.H5SecondaryHeadline,
                                                         textColor: .white70,
                                                         alignment: .left)
        }

        if let dailyPrep = dailyPrep {
            let results = dailyPrep.results.isEmpty == true ? dailyPrep.empty : dailyPrep.results
            valueViews.filter { $0.tag > dailyPrep.questionCount }.forEach { $0.isHidden = true }

            for (index, result) in results.enumerated() {
                valueLabels[index].attributedText = attributedText(letterSpacing: -1.1,
                                                                   text: result,
                                                                   font: Font.H3Subtitle,
                                                                   textColor: .white,
                                                                   alignment: .left)
                valueTitleLabels[index].attributedText = attributedText(letterSpacing: 0.2,
                                                                        text: dailyPrep.labels[index],
                                                                        font: Font.PTextSmall,
                                                                        lineSpacing: 8,
                                                                        textColor: .white70,
                                                                        alignment: .left)
            }
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
