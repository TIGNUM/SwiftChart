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

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        layoutSubviews()
    }

    func configure(sortOrder: String, title: String, description: String, imageURL: URL?, duration: String) {
        let attributedIdentifier = NSMutableAttributedString(
            string: sortOrder,
            letterSpacing: -0.7,
            font: Font.H4Identifier,
            lineSpacing: 2
        )
        identifier.attributedText = attributedIdentifier
        subTitle.attributedText = attributedTitle(text: title)
        textLabel.attributedText = Style.headline(description.uppercased(), .white).attributedString()        
        mediaInformation.attributedText = attributedTitle(text: duration)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL, placeholder: R.image.preloading(), options: nil, progressBlock: nil, completionHandler: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        subTitle.sizeToFit()
    }

    private func attributedTitle(text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(
            string: text.uppercased(),
            letterSpacing: 2.8,
            font: Font.H7Tag,
            lineSpacing: 1.5,
            textColor: .white60
        )
    }
}
