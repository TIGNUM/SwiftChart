//
//  CauseTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 20.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class CauseTableViewCell: DTResultBaseTableViewCell, Dequeueable {
    // MARK: - Properties
    @IBOutlet private weak var topTitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var explanationLabel: UILabel!
}

// MARK: - Configuration

extension CauseTableViewCell {
    func configure(cause: String, explanation: String) {
        selectionStyle = .none
        ThemeText.resultTitle.apply(R.string.localized.solveCause(), to: topTitleLabel)
        ThemeText.resultHeader2.apply(cause, to: titleLabel)
        ThemeText.resultListHeader.apply(explanation, to: explanationLabel)
    }
}
