//
//  LatestCollectionCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LatestCollectionCell: UICollectionViewCell, Dequeueable {
    
    @IBOutlet weak var latestPostImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        latestPostImageView.layer.cornerRadius = 3.0
    }
    
    func setup(headline: String, placeholderURL: URL, mediaType: String) {
        headlineLabel.attributedText = AttributedString.Library.categoryHeadline(string: headline.makingTwoLines())
        mediaTypeLabel.attributedText = AttributedString.Library.categoryMediaTypeLabel(string: mediaType)
        latestPostImageView.kf.indicatorType = .activity
        latestPostImageView.kf.setImage(with: placeholderURL)
    }
}
