//
//  SolveStrategyTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveStrategyTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var strategyTitleLabel: UILabel!
    @IBOutlet private weak var minsToReadLabel: UILabel!
    @IBOutlet private weak var hasHeaderTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var doesNotHaveHeaderTopConstraint: NSLayoutConstraint?
}

// MARK: - Configuration

extension SolveStrategyTableViewCell {

    func configure(hasHeader: Bool, title: String, minsToRead: String, headerTitle: String) {
        strategyTitleLabel.text = title
        minsToReadLabel.text = minsToRead
        headerLabel.text = headerTitle
        headerLabel.isHidden = hasHeader == false
        hasHeaderTopConstraint?.isActive = hasHeader == true
        doesNotHaveHeaderTopConstraint?.isActive = hasHeader == false
        updateConstraints()
    }
}
