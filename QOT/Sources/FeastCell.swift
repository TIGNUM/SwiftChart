//
//  FeastCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FeastCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var feastImage: UIImageView!

    func configure(with viewModel: FeastCellViewModel?) {
        feastImage.kf.setImage(with: URL(string: viewModel?.image ?? ""), placeholder: R.image.preloading())
        self.bucketTitle.text = viewModel?.title
    }
}
