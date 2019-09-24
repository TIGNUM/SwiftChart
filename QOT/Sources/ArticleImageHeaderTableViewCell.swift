//
//  ArticleImageHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 18.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleImageHeaderTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var headerImageView: UIImageView!
    let skeletonManager = SkeletonManager()

    func configure(imageURLString: String?) {
        guard let urlString = imageURLString else { return }
        skeletonManager.addOtherView(headerImageView)
        headerImageView?.setImage(url: URL(string: urlString),
                                  skeletonManager: skeletonManager)
    }
}
