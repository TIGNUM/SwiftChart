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

    static func instantiateFromNib(title: String, theme: ThemeView) -> StrategyListHeaderView {
        guard let headerView = R.nib.strategyListHeaderView.instantiate(withOwner: self).first as? StrategyListHeaderView else {
            fatalError("Cannot load header view")
        }
        headerView.configure(title: title, theme: theme)
        return headerView
    }

    func configure(title: String, theme: ThemeView) {
        theme.apply(self)
        ThemeText.strategyHeader.apply(title.uppercased(), to: titleLabel)
    }
}
