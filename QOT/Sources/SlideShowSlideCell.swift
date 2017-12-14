//
//  SlideShowSlideCell.swift
//  QOT
//
//  Created by Sam Wyndham on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SlideShowSlideCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
    }

    func configure(title: String, subtitle: String, imageName: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = UIImage(named: imageName)
    }
}
