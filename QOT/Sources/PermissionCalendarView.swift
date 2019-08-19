//
//  PermissionCalendarView.swift
//  QOT
//
//  Created by karmic on 19.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PermissionCalendarView: UIView {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var weekDayLabel: UILabel!
    @IBOutlet private weak var aboutLabel: UILabel!
    @IBOutlet private weak var listLabel01: UILabel!
    @IBOutlet private weak var listLabel02: UILabel!
    @IBOutlet private weak var listLabel03: UILabel!
    @IBOutlet private weak var listLabel04: UILabel!

    // MARK: - Load View
    static func instantiateFromNib() -> PermissionCalendarView {
        guard let view = R.nib.permissionCalendarView.instantiate(withOwner: self)
            .first as? PermissionCalendarView else { fatalError("Cannot load PermissionCalendarView") }
        return view
    }

    // MARK: Configuration
    func configure() {
        ///TODO Create CMS content
    }
}
