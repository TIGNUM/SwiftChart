//
//  LibraryCollectionLatestPostCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LibraryCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    
    @IBOutlet private weak var latestPostImageView: UIImageView!
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var mediaTypeLabel: UILabel!

    // MARK: - Setup
    
    func setup(headline: String, previewImageURL: URL?, contentItemValue: ContentItemValue?) {
        if let contentItemValue = contentItemValue {
            var mediaType = ""
            switch contentItemValue {
            case .audio: mediaType = "Audio"
            case .video: mediaType = "Video"
            default: mediaType = "Text"
            }

            mediaTypeLabel.setAttrText(text: mediaType.uppercased(), font: Font.H7Tag, lineSpacing: 0, characterSpacing: 2)
            mediaTypeLabel.textColor = .white60
        }

        headlineLabel.attributedText = Style.headlineSmall(headline.makingTwoLines().uppercased(), .white).attributedString()
        latestPostImageView.kf.setImage(with: previewImageURL, placeholder: R.image.preloading(), options: nil, progressBlock: nil, completionHandler: nil)
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        latestPostImageView.layer.masksToBounds = true
        latestPostImageView.layer.cornerRadius = 10.0
    }
}
