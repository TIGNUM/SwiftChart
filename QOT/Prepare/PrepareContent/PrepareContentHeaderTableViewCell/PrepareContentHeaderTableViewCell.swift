//
//  PrepareContentHeaderTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 10.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PrepareContentHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    func setTitle(title: String, open: Bool) {
        headerLabel.text = title
        bottomSeparator.isHidden = open
        iconImageView.image = open ? R.image.prepareContentMinusIcon() : R.image.prepareContentPlusIcon()
    }
}
