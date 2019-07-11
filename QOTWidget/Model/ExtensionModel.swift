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

    struct DailyPrep: Codable {
        let loadValue: Float
        let recoveryValue: Float
        let feedback: String?
        let displayDate: Date
    }

    struct SaveLink: Codable {
        let title: String
        let url: String
        let savedAt: Date
    }
}
