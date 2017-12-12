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
    }

    func configure(dailyPrepResults: [[String: Any?]], status: GuideViewModel.Status) {
        if dailyPrepResults.count < 5 {
            setupShortDailyPrep()
        }

        titleLabel.attributedText = attributedText(letterSpacing: 1,
                                                   text: GuideViewModel.GuideType.morningInterview.title.uppercased(),
                                                   font: Font.H4Identifier,
                                                   textColor: .white,
                                                   alignment: .left)
        typeLabel.attributedText = attributedText(letterSpacing: 2,
                                                  text: GuideViewModel.GuideType.notification.title.uppercased(),
                                                  font: Font.H7Tag,
                                                  textColor: .white40,
                                                  alignment: .left)

        for (index, result) in dailyPrepResults.enumerated() {
            valueLabels[index].attributedText = attributedText(letterSpacing: -1.1,
                                                               text: (result["value"] as? String) ?? "−",
                                                               font: Font.H3Subtitle,
                                                               textColor: (result["color"] as? UIColor) ?? .white,
                                                               alignment: .left)
            valueTitleLabels[index].attributedText = attributedText(letterSpacing: 0.2,
                                                               text: (result["title"] as? String) ?? "",
                                                               font: Font.PTextSmall,
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

    func setupShortDailyPrep() {
        valueViews.filter { $0.tag > 1 }.forEach { $0.isHidden = true }
    }

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
