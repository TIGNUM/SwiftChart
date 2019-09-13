//
//  TriggerTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MindsetShifterHeaderCell: DTResultBaseTableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Configuration

    func configure(title: String, subtitle: String) {
        selectionStyle = .none
        ThemeText.resultTitle.apply(title, to: titleLabel)
        ThemeText.resultList.apply(subtitle, to: subtitleLabel)
    }
}
