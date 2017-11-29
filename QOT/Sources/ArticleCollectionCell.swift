//
//  ArticleCollectionCell.swift
//  QOT
//
//  Created by Aamir suhial Mir on 4/13/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleCollectionCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var sortTag: UILabel!
    @IBOutlet private weak var subTitle: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var mediaInformation: UILabel!
    @IBOutlet private weak var bottomSeparator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        layoutSubviews()
    }

    func configure(articleDate: String, sortOrder: String, title: String, description: String, imageURL: URL?, duration: String, showSeparator: Bool) {

        let attributedCustomDate = NSMutableAttributedString(
            string: articleDate.uppercased(),
            letterSpacing: 0.5,
            font: Font.H7Tag,
            lineSpacing: 0
        )

        let attributedSortTag = NSMutableAttributedString(
            string: sortOrder,
            letterSpacing: -0.72,
            font: Font.H4Identifier,
            lineSpacing: 0
        )

        date.attributedText = attributedCustomDate
        date.alpha = 0.6
        date.textAlignment = .right
        sortTag.attributedText = attributedSortTag
        sortTag.textAlignment = .right
        subTitle.attributedText = attributedTitle(text: title)
        textLabel.attributedText = Style.headline(description.uppercased(), .white).attributedString()
        mediaInformation.attributedText = attributedTitle(text: duration)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL, placeholder: R.image.preloading(), options: nil, progressBlock: nil, completionHandler: nil)
        bottomSeparator.isHidden = !showSeparator
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        subTitle.sizeToFit()
    }

    private func attributedTitle(text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(
            string: text.uppercased(),
            letterSpacing: 2.8,
            font: Font.H7Tag,
            lineSpacing: 1.5,
            textColor: .white60
        )
    }
}
