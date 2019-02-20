//
//  WidgetModel.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 11/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct ExtensionModel {

    struct ToBeVision: Codable {
        let headline: String?
        let text: String?
        let imageURL: URL?
    }

    struct UpcomingEvent: Codable {
        let localID: String
        let eventName: String?
        let startDate: Date?
        let endDate: Date?
        let numberOfTasks: Int?
        let tasksCompleted: Int?
    }
}
