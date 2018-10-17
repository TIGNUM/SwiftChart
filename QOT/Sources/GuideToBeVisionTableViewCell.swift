//
//  GuideToBeVisionTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 07/05/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class GuideToBeVisionTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var shadowImageView: UIImageView!
    @IBOutlet private weak var toBeVisionImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func configure(title: String, body: String, status: Guide.Item.Status, image: URL?) {
        titleLabel.attributedText = attributedText(letterSpacing: 1,
                                                   text: title.uppercased(),
                                                   font: .H5SecondaryHeadline,
                                                   textColor: .white)

        bodyLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                  text: body,
                                                  font: .DPText,
                                                  lineSpacing: 6,
                                                  textColor: .white70)
        toBeVisionImageView.kf.setImage(with: image, placeholder: R.image.universeMytobevision())
        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
    }
}

// MARK: - Private

private extension GuideToBeVisionTableViewCell {

    func setupView() {
        statusView.maskPathByRoundingCorners()
        containerView.backgroundColor = .whiteLight12
        containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
        toBeVisionImageView.clipsToBounds = true
        shadowImageView.clipsToBounds = false
        shadowImageView.layer.shadowOpacity = 1
        shadowImageView.layer.shadowRadius = 3
        shadowImageView.layer.shadowColor = UIColor.white.cgColor
        shadowImageView.layer.shadowOffset = .zero
        circularImageView(image: toBeVisionImageView)
        circularImageView(image: shadowImageView)
    }

    func circularImageView(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = toBeVisionImageView.bounds.size.width / 2
    }

    func attributedText(letterSpacing: CGFloat = 2,
                        text: String,
                        font: UIFont,
                        lineSpacing: CGFloat = 1.4,
                        textColor: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         letterSpacing: letterSpacing,
                                         font: font,
                                         lineSpacing: lineSpacing,
                                         textColor: textColor,
                                         alignment: .left,
                                         lineBreakMode: .byTruncatingTail)
    }
}
