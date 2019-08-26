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
        return selectedTool?.title ?? ""
    }

    func tools(_ completion: @escaping ([Tool.Item]) -> Void) {
        guard let selectedID = selectedToolID else {
            completion([])
            return
        }
        qot_dal.ContentService.main.getContentCategoryById(selectedID) { (contentCategory) in
            guard let category = contentCategory else {
                completion([])
                return
            }
            let items = category.contentCollections.filter({ $0.section == .QOTLibrary }).compactMap({ (collection) -> Tool.Item? in
                let isCollection: Bool = collection.contentItems.count > 1
                let toolItemId = isCollection ? collection.remoteID ?? 0 : collection.contentItems.first?.remoteID ?? 0
                return Tool.Item(remoteID: toolItemId,
                                 categoryTitle: collection.contentCategoryTitle ?? "",
                                 title: collection.title,
                                 durationString: collection.durationString,
                                 imageURL: URL(string: collection.contentItems.first?.valueImageURL ?? ""),
                                 mediaURL: URL(string: (collection.contentItems.first?.valueMediaURL ?? "")),
                                 duration: collection.contentItems.first?.valueDuration ?? 0,
                                 isCollection: isCollection,
                                 numberOfItems: collection.contentItems.count,
                                 type: collection.contentItems.first?.format.rawValue ?? "")
            })
            completion(items)
        }
    }

    func videoTools(_ completion: @escaping ([Tool.Item]) -> Void) {
        guard let selectedID = selectedToolID else {
            completion([])
            return
        }
        qot_dal.ContentService.main.getContentCategoryById(selectedID) { [weak self] (contentCategory) in
            self?.selectedTool = contentCategory
            guard let category = contentCategory else {
                completion([])
                return
            }
            let items = category.contentCollections.filter({ $0.section == .QOTLibrary }).compactMap({ (collection) -> Tool.Item? in
                let firstItem = collection.contentItems.filter { $0.format == .video }.first
                let imageURL = URL(string: firstItem?.valueImageURL ?? "")
                return Tool.Item(remoteID: collection.remoteID ?? 0,
                                 categoryTitle: collection.contentCategoryTitle ?? "",
                                 title: collection.title,
                                 durationString: collection.durationString,
                                 imageURL: imageURL,
                                 mediaURL: URL(string: (firstItem?.valueMediaURL ?? "")),
                                 duration: firstItem?.valueDuration ?? 0,
                                 isCollection: false,
                                 numberOfItems: 1,
                                 type: collection.contentItems.first?.format.rawValue ?? "")
            })
            completion(items)
        }
    }

    func selectedCategoryId() -> Int {
        return selectedToolID ?? 0
    }
}
