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
        headerImageView?.kf.setImage(with: URL(string: urlString),
                                     placeholder: R.image.preloading(),
                                     options: nil,
                                     progressBlock: nil,
                                     completionHandler: { [weak self] (_) in
                                        guard let strongSelf = self else { return }
                                        strongSelf.skeletonManager.hide()
        })
    }
}
