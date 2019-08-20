//
//  QDMUserCalendarSetting+Ext.swift
//  QOT
//
//  Created by karmic on 17.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMUserCalendarSetting {
    var source: String? {
        return calendarId?.components(separatedBy: Toggle.seperator).last
    }
}
