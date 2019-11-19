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

    static func instantiateFromNib(title: String?, theme: ThemeView?) -> StrategyListHeaderView {
        guard let headerView = R.nib.strategyListHeaderView.instantiate(withOwner: self).first as? StrategyListHeaderView else {
            fatalError("Cannot load header view")
        }
        let baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: headerView)
        baseHeaderView?.configure(title: title, subtitle: nil)
        ThemeText.strategyHeader.apply(title?.uppercased(), to: baseHeaderView?.titleLabel)
        theme?.apply(headerView)
        baseHeaderView?.addTo(superview: headerView)

        return headerView
    }
}
