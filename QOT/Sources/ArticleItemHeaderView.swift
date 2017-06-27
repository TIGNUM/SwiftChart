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
        titleLabel.attributedText = Style.headlineSmall(header.articleTitle, .white).attributedString()
        subTitleLabel.attributedText = Style.postTitle(header.articleSubTitle, .white).attributedString()
        dateLabel.attributedText = Style.tag(header.articleDate, .white60).attributedString()
        durationLabel.attributedText = Style.tag(header.articleDuration, .white60).attributedString()
    }
}
