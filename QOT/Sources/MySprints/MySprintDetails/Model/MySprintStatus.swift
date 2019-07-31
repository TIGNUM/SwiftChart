//
//  MySprintStatus.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 26/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum MySprintStatus {
    case upcoming
    case active
    case paused(on: Date)
    case completed(on: Date)

    static func from(_ sprint: QDMSprint) -> MySprintStatus {
        if sprint.isInProgress {
            return .active
        } else if let date = sprint.completedAt {
            return .completed(on: date)
        } else if let date = sprint.pausedAt {
            return .paused(on: date)
        }
        return .upcoming
    }
}

extension MySprintStatus: Equatable {}
