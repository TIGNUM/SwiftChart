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
        categoryTitleLabel.attributedText = NSAttributedString(string: articleHeader.categoryTitle,
                                                               letterSpacing: 0.4,
                                                               font: .apercuMedium(ofSize: 12),
                                                               textColor: colorMode.text.withAlphaComponent(0.3),
                                                               alignment: .left)
        titleLabel.attributedText = NSAttributedString(string: articleHeader.title.uppercased(),
                                                       letterSpacing: 0.2,
                                                       font: .apercuLight(ofSize: 34),
                                                       lineSpacing: 4,
                                                       textColor: colorMode.text,
                                                       alignment: .left)
        setAuthor(author: articleHeader.author)
        setDetails(publishDate: articleHeader.publishDate, timeToRead: articleHeader.timeToRead)
    }
}

// MARK: - Private

private extension ArticleTextHeaderTableViewCell {
    func setAuthor(author: String?) {
        if let author = author {
            authorLabel.attributedText = NSAttributedString(string: author,
                                                            letterSpacing: 0.2,
                                                            font: .apercuMedium(ofSize: 12),
                                                            textColor: colorMode.text.withAlphaComponent(0.6),
                                                            alignment: .left)
        } else {
            authorLabel.isHidden = true
        }
    }

    func setDetails(publishDate: Date?, timeToRead: Int?) {
        if let publishDate = publishDate, let timeToRead = timeToRead {
            let dateFormatter = DateFormatter.whatsHot
            let displayDate = dateFormatter.string(from: publishDate)
            let detailText = String(format: "%@ | %d min read", displayDate, timeToRead)
            detailLabel.attributedText = NSAttributedString(string: detailText,
                                                            letterSpacing: 0.4,
                                                            font: .apercuRegular(ofSize: 12),
                                                            textColor: colorMode.text.withAlphaComponent(0.3),
                                                            alignment: .left)
        } else {
            detailLabel.isHidden = true
        }
    }
}
