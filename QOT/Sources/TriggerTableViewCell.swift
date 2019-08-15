//
//  TriggerTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TriggerTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var triggerTitleLabel: UILabel!
    @IBOutlet private weak var triggerItemLabel: UILabel!
}

// MARK: - Configuration
extension TriggerTableViewCell {
    func configure(title: String, triggerItem: String) {
        triggerTitleLabel.text = title
        triggerItemLabel.text = triggerItem
    }
}
