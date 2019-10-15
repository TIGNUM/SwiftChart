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
        qot_dal.ContentService.main.getContentCollectionBySection(.QOTLibrary, { (contentCollections) in
            guard let collections = contentCollections else {
                completion([])
                return
            }
            let categoryIds = Array(Set(collections.compactMap({ $0.categoryIDs.first })))
            qot_dal.ContentService.main.getContentCategoriesByIds(categoryIds, { (categories) in
                guard let categories = categories else {
                    completion([])
                    return
                }
                let tools = categories.compactMap({ (category) -> ToolItem? in
                    guard category.remoteID != 100037 else { return nil }
                    let itemCount = category.contentCollections.filter({ $0.section == .QOTLibrary }).count
                    return ToolItem(title: category.title,
                                    remoteID: category.remoteID ?? 0,
                                    itemCount: itemCount,
                                    sortOrder: category.sortOrder)
                })
                completion(tools.sorted(by: { $0.sortOrder > $1.sortOrder }))
            })
        })
    }

    func toolsSections() -> ToolModel {
        return ToolModel(headerTitle: AppTextService.get(AppTextKey.coach_qot_tools_view_title_header),
                         headerSubtitle: AppTextService.get(AppTextKey.coach_qot_tools_view_subtitle_header),
                         toolItems: ToolSection.allCases.map {
                            return ToolModel.Item(toolSections: $0,
                                                  title: toolSectionTitles(for: $0),
                                                  subtitle: "Number of Tools") })
    }

    func toolSectionTitles(for toolItem: ToolSection) -> String {
        switch toolItem {
        case .mindset:
            return AppTextService.get(AppTextKey.coach_qot_tools_view_title_perfomamce_mindset)
        case .nutrition:
            return AppTextService.get(AppTextKey.coach_qot_tools_view_title_performance_nutrition)
        case .movement:
            return AppTextService.get(AppTextKey.coach_qot_tools_view_title_performance_movement)
        case .recovery:
            return AppTextService.get(AppTextKey.coach_qot_tools_view_title_performance_recovery)
        case .habituation:
            return AppTextService.get(AppTextKey.coach_qot_tools_view_title_performace_habituation)
        }
    }
}
