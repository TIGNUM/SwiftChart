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

    // MARK: - Cell configuration

    func configure(title: String?,
                   publishDate: Date?,
                   author: String?,
                   timeToRead: String?,
                   imageURL: URL?,
                   isNew: Bool,
                   forcedColorMode: ThemeColorMode) {
        whatsHotComponentView.configure(title: title?.uppercased(),
                                        publishDate: publishDate,
                                        author: author,
                                        timeToRead: timeToRead,
                                        imageURL: imageURL,
                                        isNew: isNew,
                                        forcedColorMode: forcedColorMode)
    }
}
