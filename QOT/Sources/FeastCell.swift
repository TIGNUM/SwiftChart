//
//  FeastCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FeastCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var feastImage: UIImageView!

    func configure(image: String?) {
        feastImage.kf.setImage(with: URL(string: image ?? ""), placeholder: R.image.preloading())
    }
}

