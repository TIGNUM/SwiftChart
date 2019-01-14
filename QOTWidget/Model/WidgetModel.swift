//
//  WidgetModel.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 11/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct WidgetModel {
    struct ToBeVision {
        let headline: String?
        let text: String?
        let imageURL: URL?
    }

    struct UpcomingEvent {
        let eventName: String?
        let eventDate: Date?
        let numberOfTasks: Int?
        let tasksCompleted: Int?
    }
}
