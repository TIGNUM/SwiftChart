//
//  ToolsCollectionsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import UIKit

final class ToolsCollectionsWorker {

    // MARK: - Properties
    private let selectedToolID: Int?

    private var selectedTool: QDMContentCategory?

    // MARK: - Init

    init(selectedToolID: Int?) {
        self.selectedToolID = selectedToolID
    }
}

// MARK: - ToolsCollectionsWorkerInterface

extension ToolsCollectionsWorker: ToolsCollectionsWorkerInterface {
    var headerTitle: String {
        return selectedTool?.title ?? String.empty
    }

    func tools(_ completion: @escaping ([Tool.Item]) -> Void) {
        guard let selectedID = selectedToolID else {
            completion([])
            return
        }
        ContentService.main.getContentCategoryById(selectedID) { (contentCategory) in
            self.selectedTool = contentCategory
            guard let category = contentCategory else {
                completion([])
                return
            }
            let items = category.contentCollections.filter({ $0.section == .QOTLibrary }).compactMap({ (collection) -> Tool.Item? in
                let isCollection: Bool = collection.contentItems.count > 1
                let toolItemId = isCollection ? collection.remoteID ?? .zero : collection.contentItems.first?.remoteID ?? .zero
                return Tool.Item(remoteID: toolItemId,
                                 categoryTitle: collection.contentCategoryTitle ?? String.empty,
                                 title: collection.title,
                                 durationString: collection.contentItems.first?.durationString ?? String.empty,
                                 imageURL: URL(string: collection.contentItems.first?.valueImageURL ?? String.empty),
                                 mediaURL: URL(string: (collection.contentItems.first?.valueMediaURL ?? String.empty)),
                                 duration: collection.contentItems.first?.valueDuration ?? .zero,
                                 isCollection: isCollection,
                                 contentCollectionId: collection.remoteID ?? .zero,
                                 numberOfItems: collection.contentItems.count,
                                 type: collection.contentItems.first?.format.rawValue ?? String.empty)
            })
            completion(items)
        }
    }

    func selectedCategoryId() -> Int {
        return selectedToolID ?? .zero
    }

    func contentItem(for id: Int, _ completion: @escaping (QDMContentItem?) -> Void) {
        ContentService.main.getContentItemById(id, completion)
    }
}
