//
//  GuideWhatsHotTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 09/05/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class GuideWhatsHotTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var whatsHotImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var footerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    func configure(title: String, body: String, image: URL?, status: Guide.Item.Status) {
		titleLabel.font = Font.H5SecondaryHeadline
        titleLabel.attributedText = attributedText(letterSpacing: 1,
                                                   text: title.uppercased(),
                                                   font: Font.H5SecondaryHeadline,
                                                   textColor: .white,
                                                   alignment: .left)
        footerLabel.attributedText = attributedText(letterSpacing: 2,
                                                    text: "WHAT'S HOT ARTICLE",
                                                    font: Font.H7Tag,
                                                    textColor: .white40,
                                                    alignment: .left)
        let bodyAttributedString = NSMutableAttributedString(attributedString: body.attributedString())
        replaceLinks(in: bodyAttributedString)
        bodyLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                  text: bodyAttributedString.string,
                                                  font: Font.DPText,
                                                  lineSpacing: 6,
                                                  textColor: .white70,
                                                  alignment: .left)

        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
        if let imageURL = image {
            whatsHotImageView.kf.setImage(with: imageURL)
            whatsHotImageView.isHidden = false
        }
    }
}

// MARK: - Private

private extension GuideWhatsHotTableViewCell {

    func setupView() {
        whatsHotImageView.isHidden = true
		containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
		whatsHotImageView.corner(radius: Layout.CornerRadius.eight.rawValue)
        statusView.maskPathByRoundingCorners()
		containerView.backgroundColor = .whiteLight12
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
                                         lineBreakMode: .byTruncatingTail)
    }

    func replaceLinks(in attributedString: NSMutableAttributedString) {
        String.matches(for: "\\[.*?\\]\\(.*?(?=\\))\\)", in: attributedString.string).reversed().forEach { range in
            let linkSubstring = attributedString.mutableString.substring(with: range)
            let linkTitle = String.getString(for: "\\[.*\\]", in: linkSubstring).trimmingCharacters(in: ["[", "]"])
            attributedString.mutableString.replaceCharacters(in: range, with: linkTitle)
        }
    }
}
