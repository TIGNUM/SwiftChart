//
//  SlideShowSlideCell.swift
//  QOT
//
//  Created by Sam Wyndham on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SlideShowTitleOnlySlideCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
    }

    func configure(title: String, imageURL: URL) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 1,
                                                       font: .simpleFont(ofSize: 16),
                                                       lineSpacing: 1,
                                                       textColor: .white,
                                                       alignment: .center,
                                                       lineBreakMode: .byWordWrapping)
        imageView.kf.setImage(with: imageURL)
    }
}
