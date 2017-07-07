//
//  ArticleItemHeaderView.swift
//  QOT
//
//  Created by karmic on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ArticleItemHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subTitleLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var durationLabel: UILabel!

    func setupView(header: ArticleCollectionHeader) {        
        titleLabel.attributedText = attributedText(
            letterSpacing: 1,
            text: header.articleTitle.uppercased(),
            font: Font.H5SecondaryHeadline,
            textColor: .white,
            alignment: .left
        )
        subTitleLabel.attributedText = attributedText(
            text: header.articleSubTitle.uppercased(),
            font: Font.H1MainTitle,
            textColor: .white,
            alignment: .left
        )
        dateLabel.attributedText = attributedText(
            text: header.articleDate.uppercased(),
            font: Font.H7Tag,
            textColor: .white20,
            alignment: .left
        )
        durationLabel.attributedText = attributedText(
            text: header.articleDuration.uppercased(),
            font: Font.H7Tag,
            textColor: .white20,
            alignment: .left
        )
    }

    private func attributedText(letterSpacing: CGFloat = 2, text: String, font: UIFont, textColor: UIColor, alignment: NSTextAlignment) -> NSMutableAttributedString {
        return NSMutableAttributedString(
            string: text,
            letterSpacing: letterSpacing,
            font: font,
            lineSpacing: 1.4,
            textColor: textColor,
            alignment: alignment
        )
    }
}
