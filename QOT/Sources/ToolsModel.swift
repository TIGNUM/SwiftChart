//
//  ToolsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

enum ToolSection: Int, CaseIterable {
    case mindset = 0
    case nutrition
    case movement
    case recovery
    case habituation

    static var sectionValues: [ToolSection] {
        return [.mindset, .nutrition, .movement, .recovery, .habituation]
    }

    func trackingKeys() -> String {
        switch self {
        case .mindset:
            return ContentService.Tools.mindset.rawValue
        case .nutrition:
            return ContentService.Tools.nutrition.rawValue
        case .movement:
            return ContentService.Tools.movement.rawValue
        case .recovery:
            return ContentService.Tools.recovery.rawValue
        case .habituation:
            return ContentService.Tools.habituation.rawValue
        }
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
        return ToolSection.sectionValues.item(at: indexPath.row)
    }
}

struct ToolItem: Equatable {
    let title: String
    let remoteID: Int
    let itemCount: Int
    let sortOrder: Int
}
