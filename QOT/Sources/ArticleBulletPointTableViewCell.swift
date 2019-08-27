//
//  ArticleBulletPointTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleBulletPointTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var bulletLabel: UILabel!

    func configure(bullet: String) {
        ThemeText.articleBullet.apply(bullet, to: bulletLabel)
    }
}
