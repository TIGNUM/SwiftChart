//
//  GuideWhatsHotTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 09/05/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class GuideWhatsHotTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var whatsHotImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var footerLabel: UILabel!
    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var titleTopConstraintToStatus: NSLayoutConstraint!
    @IBOutlet private weak var titleTopConstraintToSuperview: NSLayoutConstraint!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Cell configuration

    func configure(title: String, body: String, image: URL?, status: Guide.Item.Status) {
        titleLabel.text = title.uppercased()
        footerLabel.text = R.string.localized.guideCardTypeWhatsHot()
        let bodyAttributedString = NSMutableAttributedString(attributedString: body.attributedString())
        replaceLinks(in: bodyAttributedString)
        bodyLabel.attributedText = bodyAttributedText(text: bodyAttributedString.string,
                                                      font: .ApercuRegular15,
                                                      breakMode: .byTruncatingTail)
        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
        syncStatusView(with: status,
                       for: statusView,
                       firstConstraint: titleTopConstraintToStatus,
                       secondConstraint: titleTopConstraintToSuperview)
        if let imageURL = image {
            whatsHotImageView.kf.setImage(with: imageURL, placeholder: R.image.preloading())
            whatsHotImageView.isHidden = false
        }
    }
}

// MARK: - Private

private extension GuideWhatsHotTableViewCell {

    func setupView() {
        titleLabel.font = .H4Identifier
        whatsHotImageView.isHidden = true
        statusView.maskPathByRoundingCorners()
        actionLabel.font = .apercuBold(ofSize: 14)
        footerLabel.textColor = .guideCardTypeGray
        footerLabel.font = .apercuRegular(ofSize: 15)
		containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
		whatsHotImageView.corner(radius: Layout.CornerRadius.eight.rawValue)
    }

    func replaceLinks(in attributedString: NSMutableAttributedString) {
        String.matches(for: "\\[.*?\\]\\(.*?(?=\\))\\)", in: attributedString.string).reversed().forEach { range in
            let linkSubstring = attributedString.mutableString.substring(with: range)
            let linkTitle = String.getString(for: "\\[.*\\]", in: linkSubstring).trimmingCharacters(in: ["[", "]"])
            attributedString.mutableString.replaceCharacters(in: range, with: linkTitle)
        }
    }
}
