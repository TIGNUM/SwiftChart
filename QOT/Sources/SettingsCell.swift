//
//  SettingsCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class SettingsCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.font = .H3Subtitle
    }

    func configure(title: String) {
        titleLabel.text = title.uppercased()
    }
}
