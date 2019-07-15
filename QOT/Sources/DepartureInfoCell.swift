//
//  DepartureInfoCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureInfoCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var departureText: UILabel!
    @IBOutlet private weak var departureImage: UIImageView!
    @IBOutlet weak var websiteLabel: UILabel!

    func configure(text: String?, image: String?, link: String?) {
        departureImage.kf.setImage(with: URL(string: image ?? ""), placeholder: R.image.preloading())
        departureText.text = text
        websiteLabel.text = link
    }
}
