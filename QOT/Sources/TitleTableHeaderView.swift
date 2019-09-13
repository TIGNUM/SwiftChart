//
//  TitleHeaderView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TitleTableHeaderView: UITableViewHeaderFooterView, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!

    // MARK: Configuration
    func configure(title: String, theme: ThemeView, themeText: ThemeText = ThemeText.myQOTTitle) {
        theme.apply(containerView)
        themeText.apply(title, to: titleLabel)
    }
}
