//
//  ToolsCollectionsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

import UIKit

final class ToolsCollectionsWorker {

    // MARK: - Properties

    private let services: Services
    private let selectedToolID: Int?

    private var selectedTool: ContentCategory? {
        return services.contentService.contentCategory(id: selectedToolID ?? 0)
    }

    // MARK: - Init

    init(services: Services, selectedToolID: Int?) {
        self.services = services
        self.selectedToolID = selectedToolID
    }
}

// MARK: - ToolsCollectionsWorkerInterface

extension ToolsCollectionsWorker: ToolsCollectionsWorkerInterface {
    var headerTitle: String {
        return selectedTool?.title ?? ""
    }

    var tools: [Tool.Item] {
        guard let selectedID = selectedToolID else { return [] }
        let toolList = services.contentService.contentCollections(categoryID: selectedID).filter { $0.section == Database.Section.library.value }
        var items = [Tool.Item]()
        toolList.forEach { (contentCollection) in
            let isCollection: Bool = contentCollection.articleItems.count > 1
            let toolItemId = isCollection ? contentCollection.remoteID.value ?? 0 : contentCollection.articleItems.first?.remoteID.value ?? 0
            items.append(Tool.Item(remoteID: toolItemId,
                                   categoryTitle: contentCollection.contentCategories.first?.title ?? "",
                                   title: contentCollection.title,
                                   durationString: contentCollection.durationString,
                                   imageURL: URL(string: contentCollection.articleItems.first?.valueImageURL ?? ""),
                                   mediaURL: URL(string: (contentCollection.articleItems.first?.valueMediaURL ?? "")),
                                   duration: contentCollection.articleItems.first?.valueDuration.value ?? 0,
                                   isCollection: isCollection,
                                   numberOfItems: contentCollection.articleItems.count,
                                   type: contentCollection.articleItems.first?.format ?? ""))
        }
        return items
    }

    var videoTools: [Tool.Item] {
        guard let selectedID = selectedToolID else { return [] }
        let toolList = services.contentService.contentCollections(categoryID: selectedID).filter { $0.section == Database.Section.library.value }
        var items = [Tool.Item]()
        toolList.forEach { (contentCollection) in
            let firstItem = contentCollection.articleItems.filter { $0.format == "video" }.first
            let imageURL = URL(string: firstItem?.valueImageURL ?? "")
            items.append(Tool.Item(remoteID: contentCollection.remoteID.value ?? 0,
                                   categoryTitle: contentCollection.contentCategories.first?.title ?? "",
                                   title: contentCollection.title,
                                   durationString: contentCollection.durationString,
                                   imageURL: imageURL,
                                   mediaURL: URL(string: (firstItem?.valueMediaURL ?? "")),
                                   duration: firstItem?.valueDuration.value ?? 0,
                                   isCollection: false,
                                   numberOfItems: 1,
                                   type: contentCollection.articleItems.first?.format ?? ""))
        }
        return items
    }
}
