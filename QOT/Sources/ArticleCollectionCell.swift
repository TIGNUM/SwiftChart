//
//  ArticleCollectionCell.swift
//  QOT
//
//  Created by Aamir suhial Mir on 4/13/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleCollectionCell: UICollectionViewCell, Dequeueable {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var identifier: UILabel!
    @IBOutlet fileprivate weak var subTitle: UILabel!
    @IBOutlet fileprivate weak var textLabel: UILabel!
    @IBOutlet fileprivate weak var mediaInformation: UILabel!
    @IBOutlet fileprivate weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = 10

    }

    func configure(sortOrder: String, title: String, description: String, imageURL: URL?, duration: String) {
        identifier.attributedText = Style.headline(sortOrder, .white).attributedString()
        subTitle.attributedText = Style.paragraph(title.uppercased(), .white60).attributedString()
        textLabel.attributedText = Style.headline(description.uppercased(), .white).attributedString()
        mediaInformation.attributedText = Style.paragraph(duration.uppercased(), .white60).attributedString()
        imageView.kf.indicatorType = .activity

        guard let imageURL = imageURL else {
            iconImageView.isHidden = true
            return
        }

        imageView.kf.setImage(with: imageURL)
    }
}
