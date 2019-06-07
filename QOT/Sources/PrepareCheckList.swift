//
//  PrepareCheckListModel.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

enum PrepareCheckListItem {
    case contentItem(itemFormat: ContentItemFormat?, title: String?)
    case eventItem(title: String, date: Date, type: String)
    case strategy(title: String, durationString: String, readMoreID: Int)
    case reminder(title: String, subbtitle: String, active: Bool)
}

enum PrepareCheckListType {
    case onTheGo
    case daily
    case peakPerformance

    enum Section: Int {
        case header = 0
        case listTitleEvents
        case events
        case listTitleIntentions
        case intentions
        case listTitleStrategies
        case strategies
        case listTitleReminders
        case reminders
    }

    var contentID: Int {
        switch self {
        case .onTheGo: return 101256
        case .daily: return 101258
        case .peakPerformance: return 101260
        }
    }
}
