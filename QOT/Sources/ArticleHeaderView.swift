//
//  ArticleHeaderView.swift
//  QOT
//
//  Created by karmic on 15.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    let skeletonManager = SkeletonManager()
    // MARK: - Lifecycle

    static func instantiateFromNib() -> ArticleHeaderView {
        guard let headerView = R.nib.articleHeaderView.instantiate(withOwner: self).first as? ArticleHeaderView else {
            fatalError("Cannot load header view")
        }
        headerView.backgroundColor = .clear
        return headerView
    }

    func configure(articleHeader: Article.Header) {
        categoryTitleLabel.attributedText = NSAttributedString(string: articleHeader.categoryTitle,
                                                               letterSpacing: 0.4,
                                                               font: .apercuMedium(ofSize: 12),
                                                               textColor: .sand30,
                                                               alignment: .left)
        titleLabel.attributedText = NSAttributedString(string: articleHeader.title.uppercased(),
                                                       letterSpacing: 0.2,
                                                       font: .apercuLight(ofSize: 34),
                                                       lineSpacing: 4,
                                                       textColor: .sand,
                                                       alignment: .left)
        setAuthor(author: articleHeader.author)
        setDetails(publishDate: articleHeader.publishDate, timeToRead: articleHeader.timeToRead)
        setImage(imageURL: articleHeader.imageURL)
    }
}

// MARK: - Private

private extension ArticleHeaderView {
    func setAuthor(author: String?) {
        if let author = author {
            authorLabel.attributedText = NSAttributedString(string: author,
                                                            letterSpacing: 0.2,
                                                            font: .apercuMedium(ofSize: 12),
                                                            textColor: .sand60,
                                                            alignment: .left)
        } else {
            authorLabel.isHidden = true
        }
    }

    func setDetails(publishDate: Date?, timeToRead: Int?) {
        if let publishDate = publishDate, let timeToRead = timeToRead {
            let dateFormatter = DateFormatter.whatsHot
            let displayDate = dateFormatter.string(from: publishDate)
            let detailText = String(format: "%@ | %d", displayDate, timeToRead)
            detailLabel.attributedText = NSAttributedString(string: detailText,
                                                            letterSpacing: 0.4,
                                                            font: .apercuRegular(ofSize: 12),
                                                            textColor: .sand30,
                                                            alignment: .left)
        } else {
            detailLabel.isHidden = true
        }
    }

    func setImage(imageURL: String?) {
        if let imageURL = imageURL {
            skeletonManager.addOtherView(imageView)
            imageView.setImage(url: URL(string: imageURL),
                               skeletonManager: self.skeletonManager)
        } else {
            imageView.isHidden = true
        }
    }
}
