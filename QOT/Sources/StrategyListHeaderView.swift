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
        headerView.backgroundColor = .clear
        headerView.configure(title: title)
        return headerView
    }

    func configure(title: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.3,
                                                       font: .apercuRegular(ofSize: 15),
                                                       lineSpacing: 8,
                                                       textColor: .sand,
                                                       alignment: .left)
    }
}
