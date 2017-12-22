//
//  SlideShowSlideCell.swift
//  QOT
//
//  Created by Sam Wyndham on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SlideShowTitleSubtitleSlideCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
    }

    func configure(title: String, subtitle: String, imageName: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 1,
                                                       font: .bentonRegularFont(ofSize: 16),
                                                       lineSpacing: 6,
                                                       textColor: .white,
                                                       alignment: .center,
                                                       lineBreakMode: .byWordWrapping)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                          letterSpacing: 1,
                                                          font: .bentonRegularFont(ofSize: 16),
                                                          lineSpacing: 6,
                                                          textColor: .white,
                                                          alignment: .center,
                                                          lineBreakMode: .byWordWrapping)
        imageView.image = UIImage(named: imageName)
    }
}
