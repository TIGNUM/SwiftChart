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

    func configure(imageURLString: String?) {
        guard let urlString = imageURLString else { return }
        headerImageView?.kf.setImage(with: URL(string: urlString), placeholder: R.image.preloading())
    }
}
