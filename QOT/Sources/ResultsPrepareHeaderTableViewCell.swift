//
//  ResultsPrepareHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String) {
        ThemeText.H01Light.apply(title, to: titleLabel)
    }
}
