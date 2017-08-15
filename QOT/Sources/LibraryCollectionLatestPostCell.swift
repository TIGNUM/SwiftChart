//
//  LibraryCollectionLatestPostCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LibraryCollectionLatestPostCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    
    @IBOutlet fileprivate weak var latestPostImageView: UIImageView!
    @IBOutlet fileprivate weak var headlineLabel: UILabel!
    @IBOutlet fileprivate weak var mediaTypeLabel: UILabel!

    // MARK: - Setup
    
    func setup(headline: String, previewImageURL: URL?, mediaType: String, sectionType: SectionType) {
        headlineLabel.attributedText = Style.headlineSmall(headline.makingTwoLines().uppercased(), .white).attributedString()
        mediaTypeLabel.attributedText = Style.tag(mediaType.uppercased(), .white60).attributedString()
        latestPostImageView.kf.setImage(with: previewImageURL, placeholder: R.image.preloading(), options: nil, progressBlock: nil, completionHandler: nil)
        latestPostImageView.layer.cornerRadius = 10.0
        latestPostImageView.layer.masksToBounds = true        
    }
}
