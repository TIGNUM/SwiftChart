//
//  ToolsItemsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsItemsWorker {

    // MARK: - Properties

    private let services: Services
    private let selectedToolID: Int?

    private lazy var selectedTool: ContentCollection? = {
        return services.contentService.contentCollection(id: selectedToolID ?? 0)
    }()

    // MARK: - Init

    init(services: Services, selectedToolID: Int?) {
        self.services = services
        self.selectedToolID = selectedToolID
    }
}

// MARK: - ToolsItemsWorkerInterface

extension ToolsItemsWorker: ToolsItemsWorkerInterface {
    var headerTitle: String {
        return selectedTool?.title ?? ""
    }

    var headerSubtitle: String {
        guard
            let selectedID = selectedToolID,
            let category = services.contentService.contentCollection(id: selectedID)?.categoryIDs.first,
            let categoryTitle = services.contentService.contentCategory(id: category.value)?.title else { return "" }
        let headerSubtitle = categoryTitle.replacingOccurrences(of: "Performance ", with: "")
        return headerSubtitle.uppercased() + " TOOLS"
    }

    var tools: [Tool.Item] {
        guard
            let selectedID = selectedToolID,
            let list = services.contentService.contentCollection(id: selectedID)?.articleItems else { return [] }
        var items = [Tool.Item]()
        list.forEach { (articleItem) in
            items.append(Tool.Item(remoteID: articleItem.remoteID.value ?? 0,
                                   categoryTitle: "",
                                   title: articleItem.valueText ?? "",
                                   durationString: articleItem.durationString,
                                   imageURL: URL(string: list.first?.valueImageURL ?? ""),
                                   mediaURL: URL(string: (articleItem.valueMediaURL ?? "")),
                                   duration: articleItem.valueDuration.value ?? 0,
                                   isCollection: false,
                                   numberOfItems: list.count,
                                   type: list.first?.format ?? ""))
        }
        return items
    }
}
