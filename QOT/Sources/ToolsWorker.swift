//
//  ToolsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ToolsWorker {

    // MARK: - Init

    init() {
    }
}

// MARK: - ToolsWorkerInterface

extension ToolsWorker: ToolsWorkerInterface {
    func tools(_ completion: @escaping ([ToolItem]) -> Void) {
        let validContentCategoryIds = [ContentCategory.PerformanceMindset,
                                       ContentCategory.PerformanceNutrition,
                                       ContentCategory.PerformanceMovement,
                                       ContentCategory.PerformanceRecovery,
                                       ContentCategory.PerformanceHabituation]
        ContentService.main.getContentCategories(validContentCategoryIds) { (categories) in
            guard let categories = categories else {
                completion([])
                return
            }
            let tools = categories.compactMap({ (category) -> ToolItem? in
                let itemCount = category.contentCollections.filter({ $0.section == .QOTLibrary }).count
                return ToolItem(title: category.title,
                                remoteID: category.remoteID ?? 0,
                                itemCount: itemCount,
                                sortOrder: category.sortOrder)
            })
            completion(tools.sorted(by: { $0.sortOrder > $1.sortOrder }))
        }
    }

    func toolsSections() -> ToolModel {
        return ToolModel(headerTitle: ScreenTitleService.main.toolsHeaderTitle(),
                         headerSubtitle: ScreenTitleService.main.toolsHeaderSubtitle(),
                         toolItems: ToolSection.allCases.map {
                            return ToolModel.Item(toolSections: $0,
                                                  title: ScreenTitleService.main.toolSectionTitles(for: $0),
                                                  subtitle: "Number of Tools") })
    }
}
