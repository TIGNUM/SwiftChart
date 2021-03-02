//
//  WorkerContent.swift
//  QOT
//
//  Created by karmic on 02.04.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class WorkerContent {
    func getContentCategoryFromItem(_ contentItem: QDMContentItem?,
                                    _ completion: @escaping (QDMContentCategory?) -> Void) {
        ContentService.main.getContentCollectionById(contentItem?.collectionID ?? .zero) { (contentCollection) in
            ContentService.main.getContentCategoriesByIds(contentCollection?.categoryIDs ?? []) { (categories) in
                completion(categories?.first)
            }
        }
    }

    func getContentCollectionsFromItems(contentItems: [QDMContentItem]?,
                                        _ completion: @escaping ([QDMContentCollection]?) -> Void) {
        let collectionIds = contentItems?.compactMap { $0.collectionID } ?? []
        ContentService.main.getContentCollectionsByIds(collectionIds, completion)
    }

    func getRelatedContents(_ relatedId: Int, completion: @escaping (([QDMContentCollection]?) -> Void)) {
        ContentService.main.getContentCollectionById(relatedId) { (content) in
            let relatedIds = content?.relatedContentIDsPrepareAll ?? []
            ContentService.main.getContentCollectionsByIds(relatedIds, completion)
        }
    }

    func getRelatedContentItems(_ relatedId: Int,
                                _ completion: @escaping (([QDMContentItem]?, [QDMContentCollection]?) -> Void)) {
        ContentService.main.getContentCollectionById(relatedId) { (content) in
            let relatedIds = content?.relatedContentItemIDs ?? []
            ContentService.main.getContentItemsByIds(relatedIds) { (items) in
                let collectionIds = items?.compactMap { $0.collectionID } ?? []
                ContentService.main.getContentCollectionsByIds(collectionIds) { (contents) in
                    completion(items, contents)
                }
            }
        }
    }

    func getCategoryIds(_ relatedContents: [QDMContentCollection]?,
                        _ relatedContentItems: [QDMContentItem]?,
                        _ completion: @escaping ([Int]) -> Void) {
        getContentCollectionsFromItems(contentItems: relatedContentItems) { (contents) in
            var contentCategoryIds = relatedContents?.flatMap { $0.categoryIDs } ?? []
            contentCategoryIds.append(contentsOf: contents?.flatMap { $0.categoryIDs } ?? [])
            completion(contentCategoryIds)
        }
    }

    func getCategories(_ relatedContents: [QDMContentCollection]?,
                       _ relatedContentItems: [QDMContentItem]?,
                       _ completion: @escaping ([QDMContentCategory]?) -> Void) {
        getCategoryIds(relatedContents, relatedContentItems) { (categoryIds) in
            ContentService.main.getContentCategoriesByIds(categoryIds, completion)
        }
    }
}
