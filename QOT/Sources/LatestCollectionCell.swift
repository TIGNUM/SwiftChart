//
//  LatestCollectionCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LatestCollectionCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    
    @IBOutlet weak var latestPostImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!

    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        latestPostImageView.layer.cornerRadius = 3.0
    }

    // MARK: - Setup
    
    func setup(headline: String, previewImageURL: URL?, mediaType: String) {
        headlineLabel.attributedText = Style.tag(headline.makingTwoLines(), .white90).attributedString()
        mediaTypeLabel.attributedText = Style.tag(mediaType, .white40).attributedString()
        latestPostImageView.kf.indicatorType = .activity
        latestPostImageView.kf.setImage(with: previewImageURL)
    }
}
