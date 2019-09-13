//
//  SolveStrategyTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveStrategyTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var strategyTitleLabel: UILabel!
    @IBOutlet private weak var minsToReadLabel: UILabel!
    @IBOutlet private weak var constraintHeaderHeight: NSLayoutConstraint!
}

// MARK: - Configuration

extension SolveStrategyTableViewCell {

    func configure(hasHeader: Bool, title: String, minsToRead: String, headerTitle: String) {
        ThemeText.resultHeader1.apply(title, to: strategyTitleLabel)
        ThemeText.resultDate.apply(minsToRead, to: minsToReadLabel)
        ThemeText.resultList.apply(headerTitle, to: headerLabel)

        let designerTopBottomMargin: CGFloat = 24 + 28
        constraintHeaderHeight.constant = hasHeader ? designerTopBottomMargin + headerLabel.bounds.height : 24
        updateConstraints()
    }
}
