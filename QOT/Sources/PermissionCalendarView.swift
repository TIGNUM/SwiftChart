//
//  PermissionCalendarView.swift
//  QOT
//
//  Created by karmic on 19.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PermissionCalendarView: UIView {

    static func instantiateFromNib() -> PermissionCalendarView {
        guard let view = R.nib.permissionCalendarView.instantiate(withOwner: self)
            .first as? PermissionCalendarView else { fatalError("Cannot load PermissionCalendarView") }
        return view
    }
}
