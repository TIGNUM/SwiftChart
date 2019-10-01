//
//  ArticleTextHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 18.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleEmptyTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var fakeImageView: UIView!
    @IBOutlet private weak var fakeTextLabel: UILabel!
    let skeletonManager = SkeletonManager()

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(categoryTitleLabel)
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(authorLabel)
        skeletonManager.addSubtitle(detailLabel)
        skeletonManager.addSubtitle(fakeTextLabel)
        skeletonManager.addOtherView(fakeImageView)
    }

    deinit {
        skeletonManager.hide()
    }
}
