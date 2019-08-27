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
    func configure(title: String) {
        ThemeView.level2.apply(containerView)
        ThemeText.myQOTTitle.apply(title, to: titleLabel)
    }
}
