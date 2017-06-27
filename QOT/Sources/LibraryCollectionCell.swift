//
//  LibraryCollectionCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LibraryCollectionCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    
    @IBOutlet fileprivate weak var latestPostImageView: UIImageView!
    @IBOutlet fileprivate weak var headlineLabel: UILabel!
    @IBOutlet fileprivate weak var mediaTypeLabel: UILabel!
    @IBOutlet fileprivate weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var titleLabelConstraintLeft: NSLayoutConstraint!
    @IBOutlet fileprivate weak var subTitleLabelConstraintLeft: NSLayoutConstraint!
    @IBOutlet fileprivate weak var titleLabelConstraintRight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var subTitleLabelConstraintRight: NSLayoutConstraint!

    // MARK: - Setup
    
    func setup(headline: String, previewImageURL: URL?, mediaType: String, sectionType: SectionType) {
        headlineLabel.attributedText = Style.tag(headline.makingTwoLines(), .white90).attributedString()
        mediaTypeLabel.attributedText = Style.tag(mediaType, .white40).attributedString()
        latestPostImageView.kf.setImage(with: previewImageURL)
        latestPostImageView.layer.cornerRadius = 10.0
        latestPostImageView.layer.masksToBounds = true
        imageBottomConstraint.constant = sectionType.imageBottomConstraint
        titleLabelConstraintLeft.constant = sectionType.labelLeftRightMarging
        titleLabelConstraintRight.constant = sectionType.labelLeftRightMarging
        subTitleLabelConstraintLeft.constant = sectionType.labelLeftRightMarging
        subTitleLabelConstraintLeft.constant = sectionType.labelLeftRightMarging
    }
}
