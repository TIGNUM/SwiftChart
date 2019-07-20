//
//  MySprintListSprintModel.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 16/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MySprintsListSprintModel {
    enum StatusType {
        case active
        case upcoming
        case paused
        case completed
    }

    let title: String
    let status: StatusType
    let progress: String
    let statusDescription: String

    let identifier: String
    let createdDate: Date
    let completedDate: Date?
    let orderingNumber: Int

    var isRemovable: Bool {
        return status != .active
    }

    var isReordable: Bool {
        return status == .upcoming
    }
}
