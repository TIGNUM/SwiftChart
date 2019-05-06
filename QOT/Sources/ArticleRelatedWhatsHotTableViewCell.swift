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

    // MARK: - Cell configuration

    func configure(title: String?,
                   publishDate: Date?,
                   author: String?,
                   timeToRead: String?,
                   imageURL: URL?,
                   isNew: Bool) {
        whatsHotComponentView.configure(title: title,
                                        publishDate: publishDate,
                                        author: author,
                                        timeToRead: timeToRead,
                                        imageURL: imageURL,
                                        isNew: isNew)
    }
}
