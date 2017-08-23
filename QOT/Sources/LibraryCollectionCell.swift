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

    func setup(headline: String, previewImageURL: URL?, contentItemValue: ContentItemValue?, sectionType: SectionType) {
        if let contentItemValue = contentItemValue {
            var mediaType = ""
            switch contentItemValue {
            case .audio: mediaType = "Audio"
            case .video: mediaType = "Video"
            default: mediaType = "Text"
            }

            mediaTypeLabel.prepareAndSetTextAttributes(text: mediaType.uppercased(), font: Font.H7Tag, characterSpacing: 2)
            mediaTypeLabel.textColor = .white60
        }

        headlineLabel.attributedText = Style.headlineSmall(headline.makingTwoLines().uppercased(), .white).attributedString()
        latestPostImageView.kf.setImage(with: previewImageURL, placeholder: R.image.preloading(), options: nil, progressBlock: nil, completionHandler: nil)
        latestPostImageView.layer.cornerRadius = 10.0
        latestPostImageView.layer.masksToBounds = true
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }
}
