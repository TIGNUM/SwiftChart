//
//  BeSpokeCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class BeSpokeCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var secondImageView: UIImageView!
    @IBOutlet private weak var firstImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var tilteContainerView: UIView!
    @IBOutlet private weak var descriptionContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .carbon
    }

    func configure(data: BeSpokeCellViewModel) {
        imageContainerView.isHidden = data.images.isEmpty
        secondImageView.isHidden = data.images.count == 1
        tilteContainerView.isHidden = data.attributedTitle == nil
        descriptionContainerView.isHidden = data.attributedDescription == nil
        headingLabel.attributedText = data.attributedHeading
        descriptionLabel.attributedText = data.attributedDescription
        titleLabel.attributedText = data.attributedTitle
        if let firstImageUrl = data.images.first {
            firstImageView.kf.setImage(with: firstImageUrl, placeholder: R.image.preloading())
        }
        if data.images.count > 1 {
            let secondImageUrl = data.images[1]
            secondImageView.kf.setImage(with: secondImageUrl, placeholder: R.image.preloading())
        }
    }
}
