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
    let skeletonManager = SkeletonManager()

    static func instantiateFromNib(title: String?, theme: ThemeView?) -> StrategyListHeaderView {
        guard let headerView = R.nib.strategyListHeaderView.instantiate(withOwner: self).first as? StrategyListHeaderView else {
            fatalError("Cannot load header view")
        }

        headerView.configure(title: title, theme: theme)
        return headerView
    }

    func configure(title: String?, theme: ThemeView?) {
        guard let titleText = title, let themeType = theme else {
            skeletonManager.addTitle(titleLabel)
            return
        }
        skeletonManager.hide()
        themeType.apply(self)
        ThemeText.strategyHeader.apply(titleText.uppercased(), to: titleLabel)
    }
}
