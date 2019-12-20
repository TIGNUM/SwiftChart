//
//  MyQOTAdminEditSprintsDetailsWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum SprintSettingType {
    case Int
    case Date
    case String
    case Bool
}

enum SprintProperty: String {
    case remoteID = "Remote ID"
    case createdAt = "Created"
    case modifiedAt = "Modified"
    case createdOnDevice = "Created on device"
    case qotId = "QOT ID"

    case nextDay = "Next day"
    case startDate = "Start date"
    case pausedAt = "Paused at"
    case completedAt = "Completed at"
    case title = "Title"
    case subtitle = "Subtitle"
    case sortOrder = "Sort order"
    case currentDay = "Current day"
    case contentCollectionId = "Content collection ID"

    case notesReflection = "Notes Reflection"
    case notesLearnings = "Notes Learnings"
    case notesBenefits = "Notes Benefits"
    case isInProgress = "Is in progress"

    case completedDays = "Completed days"
}

final class MyQOTAdminEditSprintsDetailsWorker {
    let sprint: QDMSprint
    var datasource: [(type: SprintSettingType, property: SprintProperty, value: Any)] = []

    // MARK: - Init
    init(sprint: QDMSprint) {
        self.sprint = sprint
        createDatasource()
    }

    func createDatasource() {
        datasource.append((type: .Int, property: .remoteID, value: sprint.remoteID ?? 0))
        datasource.append((type: .Date, property: .createdAt, value: sprint.createdAt ?? Date()))
        datasource.append((type: .Date, property: .modifiedAt, value: sprint.modifiedAt ?? Date()))
        datasource.append((type: .Date, property: .createdOnDevice, value: sprint.createdOnDevice ?? Date()))
        datasource.append((type: .Int, property: .qotId, value: sprint.qotId ?? 0))
        datasource.append((type: .Date, property: .nextDay, value: sprint.nextDay ?? Date()))
        datasource.append((type: .Date, property: .startDate, value: sprint.startDate ?? Date()))
        datasource.append((type: .Date, property: .pausedAt, value: sprint.pausedAt ?? Date()))
        datasource.append((type: .Date, property: .completedAt, value: sprint.completedAt ?? Date()))
        datasource.append((type: .String, property: .title, value: sprint.title ?? ""))
        datasource.append((type: .String, property: .subtitle, value: sprint.subtitle ?? ""))
        datasource.append((type: .Int, property: .sortOrder, value: sprint.sortOrder))
        datasource.append((type: .Int, property: .currentDay, value: sprint.currentDay))
        datasource.append((type: .Int, property: .contentCollectionId, value: sprint.contentCollectionId ?? 0))
        datasource.append((type: .String, property: .notesReflection, value: sprint.notesReflection ?? ""))
        datasource.append((type: .String, property: .notesLearnings, value: sprint.notesLearnings ?? ""))
        datasource.append((type: .String, property: .notesBenefits, value: sprint.notesBenefits ?? ""))
        datasource.append((type: .Bool, property: .isInProgress, value: sprint.isInProgress))
        datasource.append((type: .Int, property: .completedDays, value: sprint.completedDays))
    }
}
