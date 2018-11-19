//
//  GuidePreparationTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 17.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class GuidePreparationTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var topConstraintToStatus: NSLayoutConstraint!
    @IBOutlet private weak var topConstraintToSuperview: NSLayoutConstraint!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.maskPathByRoundingCorners()
        typeLabel.textColor = .guideCardTypeGray
        actionLabel.font = .ApercuBold14
        typeLabel.font = .ApercuRegular13
        titleLabel.font = .ApercuBold18
        bodyLabel.alpha = Layout.Transparency.alpha_08
        containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
    }

    // MARK: - Cell configruation

    func configure(title: String, body: String, status: Guide.Item.Status) {
        bodyLabel.attributedText = bodyAttributedText(text: body, font: .ApercuRegular15)
        titleLabel.text = title.uppercased()
        containerView.alpha = status == .todo ? 0.7 : 1
        containerView.backgroundColor = status.cardColor
        statusView.backgroundColor = status.statusViewColor
        syncStatusView(with: status,
                       for: statusView,
                       firstConstraint: topConstraintToStatus,
                       secondConstraint: topConstraintToSuperview)
    }
}
