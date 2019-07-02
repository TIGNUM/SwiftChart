//
//  CauseTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 20.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class CauseTableViewCell: UITableViewCell, Dequeueable {
    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var explanationLabel: UILabel!
}

// MARK: - Configuration

extension CauseTableViewCell {
    func configure(cause: String, explanation: String) {
        titleLabel.text = cause
        explanationLabel.text = explanation
    }
}
