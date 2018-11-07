//
//  GuideToBeVisionTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 07/05/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class GuideToBeVisionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var shadowImageView: UIImageView!
    @IBOutlet private weak var toBeVisionImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var cardTypeLabel: UILabel!
    @IBOutlet private weak var titleTopConstraintToStatus: NSLayoutConstraint!
    @IBOutlet private weak var titleTopConstraintToSuperview: NSLayoutConstraint!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Cell configuration

    func configure(title: String, body: String, status: Guide.Item.Status, image: URL?) {
        titleLabel.text = title.uppercased()
        bodyLabel.attributedText = bodyAttributedText(text: body, font: .ApercuRegular15)
        toBeVisionImageView.kf.setImage(with: image, placeholder: R.image.universeMytobevision())
        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
        syncStatusView(with: status,
                       for: statusView,
                       firstConstraint: titleTopConstraintToStatus,
                       secondConstraint: titleTopConstraintToSuperview)
    }
}

// MARK: - Private

private extension GuideToBeVisionTableViewCell {

    func setupView() {
        cardTypeLabel.font = .ApercuMedium31
        titleLabel.font = .H4Identifier
        statusView.maskPathByRoundingCorners()
        bodyLabel.lineBreakMode = .byTruncatingTail
        containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
        toBeVisionImageView.clipsToBounds = true
        shadowImageView.clipsToBounds = false
        shadowImageView.layer.shadowOpacity = 1
        shadowImageView.layer.shadowRadius = 3
        shadowImageView.layer.shadowColor = UIColor.white.cgColor
        shadowImageView.layer.shadowOffset = .zero
        actionLabel.font = .ApercuBold14
        circularImageView(image: toBeVisionImageView)
        circularImageView(image: shadowImageView)
    }

    func circularImageView(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = toBeVisionImageView.bounds.size.width / 2
    }
}
