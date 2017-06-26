//
//  ArticleRelatedCell.swift
//  QOT
//
//  Created by karmic on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

final class ArticleRelatedCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!

    func setupView(title: String, subTitle: String, previewImageURL: URL?) {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        previewImageView.kf.setImage(with: previewImageURL)
        previewImageView.layer.cornerRadius = 8
        titleLabel.attributedText = Style.headline(title.uppercased(), .white).attributedString()
        subTitleLabel.attributedText = Style.paragraph(subTitle.uppercased(), .whiteLightTwo).attributedString()
    }
}
