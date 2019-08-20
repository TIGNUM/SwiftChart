//
//  EKEventStore+Ext.swift
//  QOT
//
//  Created by karmic on 17.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import EventKit

extension EKEventStore {
    var localIds: [String] {
        return calendars(for: .event).compactMap { String($0.toggleIdentifier) }
    }
}
