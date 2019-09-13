//
//  TriggerTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TriggerTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var triggerTitleLabel: UILabel!
    @IBOutlet private weak var triggerItemLabel: UILabel!
}

// MARK: - Configuration
extension TriggerTableViewCell {
    func configure(title: String, triggerItem: String) {
        selectionStyle = .none
        ThemeText.resultTitle.apply(title, to: triggerTitleLabel)
        ThemeText.resultHeader2.apply(triggerItem, to: triggerItemLabel)
    }
}
