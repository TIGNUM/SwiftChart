//
//  ResultsPrepareDashTitleTableViewCell.swift
//  QOT
//
//  Created by karmic on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareDashTitleTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String) {
        ThemeText.Text01Light.apply(title, to: titleLabel)
    }
}
