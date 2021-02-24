//
//  ToolsItemsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ToolsItemsWorker {

    // MARK: - Properties
    private let selectedToolID: Int?

    private var selectedTool: QDMContentCollection?

    var toolItems = [Tool.Item]()
    // MARK: - Init

    init(selectedToolID: Int?) {
        self.selectedToolID = selectedToolID
    }
}

// MARK: - ToolsItemsWorkerInterface

extension ToolsItemsWorker: ToolsItemsWorkerInterface {
    var headerTitle: String {
        return selectedTool?.title ?? String.empty
    }

    var headerSubtitle: String {
        guard let categoryTitle = self.selectedTool?.contentCategoryTitle else { return String.empty }
        let headerSubtitle = categoryTitle.replacingOccurrences(of: "Performance ", with: String.empty)
        return headerSubtitle + " tools"
    }

    var tools: [Tool.Item] {
        return toolItems
    }

    func load(_ completion: @escaping () -> Void) {
        guard let contentCollectionId = self.selectedToolID else {
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        ContentService.main.getContentCollectionById(contentCollectionId) { [weak self] (contentCollection) in
            self?.selectedTool = contentCollection
            let count = contentCollection?.contentItems.count ?? 0
            self?.toolItems = contentCollection?.contentItems.compactMap({ (contentItem) -> Tool.Item? in
                Tool.Item(remoteID: contentItem.remoteID ?? 0,
                          categoryTitle: String.empty,
                          title: contentItem.valueText,
                          durationString: contentItem.durationString,
                          imageURL: URL(string: contentItem.valueImageURL ?? String.empty),
                          mediaURL: URL(string: (contentItem.valueMediaURL ?? String.empty)),
                          duration: contentItem.valueDuration ?? 0,
                          isCollection: false,
                          contentCollectionId: contentCollection?.remoteID ?? 0,
                          numberOfItems: count,
                          type: contentItem.format.rawValue)
            }) ?? []
            completion()
        }
    }

    func selectedContentId() -> Int {
        return selectedToolID ?? 0
    }
}
