//
//  WhatsHotCell.swift
//  QOT
//
//  Created by Aamir suhial Mir on 4/13/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

class WhatsHotCell: UICollectionViewCell, Dequeueable {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var identifier: UILabel!
    @IBOutlet fileprivate weak var subTitle: UILabel!
    @IBOutlet fileprivate weak var textLabel: UILabel!
    @IBOutlet fileprivate weak var mediaInformation: UILabel!
    @IBOutlet fileprivate weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 2
    }
}

extension WhatsHotCell {
    func configure(with item: WhatsHotItem) {
        identifier.attributedText = item.identifier
        subTitle.attributedText = item.subtitle
        textLabel.attributedText = item.text
        mediaInformation.attributedText = item.mediaInformation
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: item.placeholderURL)
        iconImageView.isHidden = !item.bookmarked
    }
}
