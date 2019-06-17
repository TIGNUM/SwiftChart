//
//  ToolsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsWorker {

    // MARK: - Properties

    private let services: Services?

    // MARK: - Init

    init(services: Services?) {
        self.services = services
    }
}

// MARK: - ToolsWorkerInterface

extension ToolsWorker: ToolsWorkerInterface {
    var tools: [ToolItem] {
        guard let tools = services?.contentService.toolsCategories() else { return [] }
        var toolItems: [ToolItem] = []
        for tool in tools {
            let itemCount = tool.itemCount(section: .library)
            toolItems.append(ToolItem(title: tool.title,
                                      remoteID: tool.remoteID.value ?? 0,
                                      itemCount: itemCount,
                                      sortOrder: tool.sortOrder))
        }
        return toolItems.sorted(by: { (lhs, rhs) -> Bool in
            lhs.sortOrder < rhs.sortOrder
        }).reversed()
    }

    func toolsSections() -> ToolModel {
        return ToolModel(headerTitle: services?.contentService.toolsHeaderTitle(),
                         headerSubtitle: services?.contentService.toolsHeaderSubtitle(),
                         toolItems: ToolSection.allCases.map {
                            return ToolModel.Item(toolSections: $0,
                                                  title: services?.contentService.toolSectionTitles(for: $0),
                                                  subtitle: "Number of Tools") })
    }

    func trackingKeys(at indexPath: IndexPath) -> String {
        let item = ToolSection.sectionValues.item(at: indexPath.row)
        guard let services = services else {
        return ""
        }
        return item.trackingKeys(for: services)
    }
}
