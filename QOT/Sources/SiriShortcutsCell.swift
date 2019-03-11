//
//  SiriShortcutsCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SiriShortcutsCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        titleLabel.textColor = .white
        accessoryType = .disclosureIndicator
    }

    func configure(title: String?) {
        titleLabel.text = title ?? ""
    }
}
