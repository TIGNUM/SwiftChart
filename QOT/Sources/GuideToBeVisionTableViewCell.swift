//
//  GuideToBeVisionTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 07/05/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol GuideToBeVisionTableViewCellDelegate: class {
    func didTapToBeVisionInfoButton()
}

final class GuideToBeVisionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var toBeVisionImageView: UIImageView!
    @IBOutlet private weak var toBeVisionGradientImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var cardTypeLabel: UILabel!
    @IBOutlet private weak var titleTopConstraintToStatus: NSLayoutConstraint!
    @IBOutlet private weak var titleTopConstraintToSuperview: NSLayoutConstraint!
    weak var delegate: GuideToBeVisionTableViewCellDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Cell configuration

    func configure(title: String, body: String, status: Guide.Item.Status, image: URL?) {
        titleLabel.text = title.uppercased()
        containerView.alpha = status == .todo ? 0.7 : 1
        bodyLabel.attributedText = bodyAttributedText(text: body, font: .ApercuRegular15, breakMode: .byTruncatingTail)
        toBeVisionImageView.kf.setImage(with: image, placeholder: R.image.tbv_placeholder())
        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
        toBeVisionGradientImageView.image = status == .todo ? R.image.tbv_gradient_todo() : R.image.tbv_gradient_done()
        syncStatusView(with: status,
                       for: statusView,
                       firstConstraint: titleTopConstraintToStatus,
                       secondConstraint: titleTopConstraintToSuperview)
    }
}

// MARK: - Private

private extension GuideToBeVisionTableViewCell {

    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapToBeVisionInfoButton()
    }

    func setupView() {
        cardTypeLabel.font = .ApercuMedium31
        titleLabel.font = .ApercuBold18
        statusView.maskPathByRoundingCorners()
        bodyLabel.lineBreakMode = .byTruncatingTail
        containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
        toBeVisionImageView.clipsToBounds = true
        actionLabel.font = .ApercuBold14
        bodyLabel.alpha = Layout.Transparency.alpha_08
    }

    func circularImageView(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = toBeVisionImageView.bounds.size.width / 2
    }
}
