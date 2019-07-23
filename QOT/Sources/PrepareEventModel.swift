//
//  PrepareEventModel.swift
//  QOT
//
//  Created by karmic on 22.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct PrepareEvent {
    let title: String?
    let dateString: String?
    let date: Date?
    let userCalendarEvent: QDMUserCalendarEvent?
    let userPreparation: QDMUserPreparation?
}
