//
//  CalendarEventSelectionHeaderView.swift
//  QOT
//
//  Created by karmic on 19.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class CalendarEventSelectionHeaderView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String) {
        ThemeText.Text01LightCarbon100.apply(title, to: titleLabel)
    }
}
