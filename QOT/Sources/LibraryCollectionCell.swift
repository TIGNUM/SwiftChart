//
//  LibraryCollectionCell.swift
//  QOT
//
//  Created by karmic on 14.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LibraryCollectionCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet fileprivate weak var latestPostImageView: UIImageView!
    @IBOutlet fileprivate weak var headlineLabel: UILabel!
    @IBOutlet fileprivate weak var mediaTypeLabel: UILabel!

    // MARK: - Setup

    func setup(headline: String, previewImageURL: URL?, mediaType: String?, sectionType: SectionType) {
        if let mediaType = mediaType {
            mediaTypeLabel.attributedText = Style.tag(mediaType.uppercased(), .white60).attributedString()
        }

        headlineLabel.attributedText = Style.headlineSmall(headline.makingTwoLines(), .white).attributedString()
        latestPostImageView.kf.setImage(with: previewImageURL, placeholder: R.image.preloading(), options: nil, progressBlock: nil, completionHandler: nil)
        latestPostImageView.layer.cornerRadius = 10.0
        latestPostImageView.layer.masksToBounds = true
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }
}
