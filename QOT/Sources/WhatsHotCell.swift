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

    func configure(with item: LearnWhatsHotContentItem) {
        identifier.attributedText = Style.headline(".087", .white).attributedString()
        subTitle.attributedText = Style.paragraph("Q O T   / /   T H O U G H T S", .white60).attributedString()
        textLabel.attributedText = Style.headline("IMPACT OF EXTRINSIC POLJ MOTIVATION ON INTRINSIC", .white).attributedString()
        mediaInformation.attributedText = Style.paragraph("V I D E O     /  /    2   M I N", .white60).attributedString()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string:"https://static.pexels.com/photos/348323/pexels-photo-348323.jpeg")!)
        iconImageView.isHidden = true
    }
}
