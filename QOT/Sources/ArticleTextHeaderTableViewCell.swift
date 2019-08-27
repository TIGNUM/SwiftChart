//
//  ArticleTextHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 18.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleTextHeaderTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!

    // MARK: - Life Cycle

    func configure(articleHeader: Article.Header?) {
        guard let articleHeader = articleHeader else { return }
        ThemeText.articleCategory.apply(articleHeader.categoryTitle, to: categoryTitleLabel)
        ThemeText.articleTitle.apply(articleHeader.title, to: titleLabel)
        setAuthor(author: articleHeader.author)
        setDetails(publishDate: articleHeader.publishDate, timeToRead: articleHeader.timeToRead)
    }
}

// MARK: - Private

private extension ArticleTextHeaderTableViewCell {
    func setAuthor(author: String?) {
        if let author = author {
            ThemeText.articleAuthor.apply(author, to: authorLabel)
        } else {
            authorLabel.isHidden = true
        }
    }

    func setDetails(publishDate: Date?, timeToRead: Int?) {
        if let publishDate = publishDate, let timeToRead = timeToRead {
            let dateFormatter = DateFormatter.whatsHot
            let displayDate = dateFormatter.string(from: publishDate)
            let detailText = String(format: "%@ | %d min read", displayDate, timeToRead)
            ThemeText.articleDatestamp.apply(detailText, to: detailLabel)
        } else {
            detailLabel.isHidden = true
        }
    }
}
