//
//  ComponentHeaderView.swift
//  QOT
//
//  Created by karmic on 02.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ComponentHeaderView: UICollectionReusableView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    func configure(title: String?, subtitle: String?) {
        guard let title = title, let subtitle = subtitle else { return }
        ThemeText.strategyHeader.apply(title, to: titleLabel)
        ThemeText.strategySubHeader.apply(subtitle, to: subtitleLabel)
        ThemeView.level1.apply(self) 
    }
}
