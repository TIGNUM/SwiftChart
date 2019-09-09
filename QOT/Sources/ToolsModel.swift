//
//  ToolsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum ToolSection: Int, CaseIterable {
    case mindset = 0
    case nutrition
    case movement
    case recovery
    case habituation

    static var sectionValues: [ToolSection] {
        return [.mindset, .nutrition, .movement, .recovery, .habituation]
    }

    func tag() -> Tags {
        switch self {
        case .mindset:
            return .ToolsMindset
        case .nutrition:
            return .ToolsNutrition
        case .movement:
            return .ToolsMovement
        case .recovery:
            return .ToolsRecovery
        case .habituation:
            return .ToolsHabituation
        }
    }

    func trackingKeys() -> String {
        return tag().rawValue
    }
}

struct ToolModel {
    let headerTitle: String?
    let headerSubtitle: String?
    let toolItems: [Item]

    struct Item {
        let toolSections: ToolSection
        let title: String?
        let subtitle: String?
    }

    // MARK: - Properties

    func sectionItem(at indexPath: IndexPath) -> ToolSection {
        return ToolSection.sectionValues.at(index: indexPath.row) ?? .mindset
    }
}

struct ToolItem: Equatable {
    let title: String
    let remoteID: Int
    let itemCount: Int
    let sortOrder: Int
}
