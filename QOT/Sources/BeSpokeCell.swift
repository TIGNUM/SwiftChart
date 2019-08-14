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
    @IBOutlet private weak var firstImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var tilteContainerView: UIView!
    @IBOutlet private weak var descriptionContainerView: UIView!

    func configure(with viewModel: BeSpokeCellViewModel?) {
        headingLabel.text = viewModel?.bucketTitle
        titleLabel.text = viewModel?.title
        descriptionLabel.text = viewModel?.description
        firstImageView.kf.setImage(with: URL(string: viewModel?.image ?? ""), placeholder: R.image.preloading())
    }
}
