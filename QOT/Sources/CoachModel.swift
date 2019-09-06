//
//  CoachModel.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum CoachSection: Int, CaseIterable {
    case search = 0
    case tools
    case sprint
    case event
    case challenge

    static var sectionValues: [CoachSection] {
        return [.search, .tools, .sprint, .event, .challenge]
    }

    func tag() -> Tags {
        switch self {
        case .search:
            return .CoachSearch
        case .tools:
            return .CoachTools
        case .sprint:
            return .CoachSprint
        case .event:
            return .CoachEvent
        case .challenge:
            return .CoachChallenge
        }
    }

    func trackingKeys() -> String {
        return tag().rawValue
    }
}

struct CoachModel {
    let headerTitle: String?
    let headerSubtitle: String?
    let coachItems: [Item]

    struct Item {
        let coachSections: CoachSection
        let title: String?
        let subtitle: String?
    }

    // MARK: - Properties

    func sectionItem(at indexPath: IndexPath) -> CoachSection {
        return CoachSection.sectionValues.item(at: indexPath.row)
    }
}
