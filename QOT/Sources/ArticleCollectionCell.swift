//
//  ArticleCollectionCell.swift
//  QOT
//
//  Created by Aamir suhial Mir on 4/13/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ArticleCollectionCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var sortTag: UILabel!
    @IBOutlet private weak var subTitle: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var mediaInformation: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var bottomSeparator: UIView!
    @IBOutlet private weak var newArticleIndicator: UIView!

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMdd")
        dateFormatter.locale = .current
        return dateFormatter
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        imageView.backgroundColor = .clear
        imageView.corner(radius: Layout.CornerRadius.eight.rawValue)
        layoutSubviews()
    }

    func configure(author: String,
                   articleDate: Date,
                   sortOrder: String,
                   title: String,
                   description: String,
                   imageURL: URL?,
                   duration: String,
                   showSeparator: Bool,
                   newArticle: Bool) {
        let attributedCustomDate = NSMutableAttributedString(string: dateFormatter.string(from: articleDate).uppercased(),
                                                             letterSpacing: 0.5,
                                                             font: Font.H7Tag,
                                                             lineSpacing: 0)
        let attributedSortTag = NSMutableAttributedString(string: sortOrder,
                                                          letterSpacing: -0.72,
                                                          font: Font.H4Identifier,
                                                          lineSpacing: 0)
        date.attributedText = attributedCustomDate
        date.alpha = 0.6
        date.textAlignment = .right
        sortTag.attributedText = attributedSortTag
        sortTag.textAlignment = .right
        subTitle.attributedText = attributedTitle(text: title)
        authorLabel.attributedText = attributedTitle(text: author)
        textLabel.attributedText = Style.headline(description.uppercased(), .white).attributedString()
        mediaInformation.attributedText = attributedTitle(text: duration)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL, placeholder: R.image.preloading())
        bottomSeparator.isHidden = !showSeparator
        newArticleIndicator.isHidden = !newArticle
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
