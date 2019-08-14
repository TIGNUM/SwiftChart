//
//  DepartureInfoCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureInfoCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var departureText: UILabel!
    @IBOutlet private weak var departureImage: UIImageView!
    @IBOutlet private weak var websiteLabel: UILabel!

    func configure(with viewModel: DepartureInfoCellViewModel?) {
        self.subtitleLabel.text = viewModel?.subtitle
        self.bucketTitle.text = viewModel?.title
        departureImage.kf.setImage(with: URL(string: viewModel?.image ?? ""), placeholder: R.image.preloading())
        departureText.text = viewModel?.text
        websiteLabel.text = viewModel?.link
    }
}
