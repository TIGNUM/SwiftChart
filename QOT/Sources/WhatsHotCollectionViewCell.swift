//
//  WhatsHotCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 26.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class WhatsHotCollectionViewCell: ComponentCollectionViewCell {

    // MARK: - Properties

    @IBOutlet weak var whatsHotComponentView: WhatsHotComponentView!

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
                   isNew: Bool) {
        whatsHotComponentView.configure(title: title,
                                        publishDate: publishDate,
                                        author: author,
                                        timeToRead: timeToRead,
                                        imageURL: imageURL,
                                        isNew: isNew)
    }
}
