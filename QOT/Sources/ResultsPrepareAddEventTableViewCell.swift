//
//  ResultsPrepareAddEventTableViewCell.swift
//  QOT
//
//  Created by karmic on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareAddEventTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryView = UIImageView(image: R.image.ic_disclosure_accent())
    }

    func configure(title: String, subtitle: String) {
        ThemeText.H02Light.apply(title, to: titleLabel)
        ThemeText.Text02Light.apply(subtitle, to: subtitleLabel)
    }
}
