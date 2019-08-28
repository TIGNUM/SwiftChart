//
//  ArticleRelatedWhatsHotTableViewCell.swift
//  QOT
//
//  Created by karmic on 18.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleRelatedWhatsHotTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var whatsHotComponentView: WhatsHotComponentView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .carbon
        contentView.backgroundColor = .carbon
    }

    // MARK: - Cell configuration

    func configure(title: String?,
                   publishDate: Date?,
                   author: String?,
                   timeToRead: String?,
                   imageURL: URL?,
                   isNew: Bool,
                   forcedColorMode: ThemeColorMode?) {
        whatsHotComponentView.configure(title: title,
                                        publishDate: publishDate,
                                        author: author,
                                        timeToRead: timeToRead,
                                        imageURL: imageURL,
                                        isNew: isNew,
                                        forcedColorMode: forcedColorMode)
    }
}
