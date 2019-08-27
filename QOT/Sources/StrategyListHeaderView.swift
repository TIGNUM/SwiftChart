//
//  StrategyListHeaderView.swift
//  QOT
//
//  Created by karmic on 23.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class StrategyListHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!

    static func instantiateFromNib(title: String) -> StrategyListHeaderView {
        guard let headerView = R.nib.strategyListHeaderView.instantiate(withOwner: self).first as? StrategyListHeaderView else {
            fatalError("Cannot load header view")
        }
        headerView.configure(title: title)
        return headerView
    }

    func configure(title: String) {
        ThemeText.strategyHeader.apply(title, to: titleLabel)
    }
}
