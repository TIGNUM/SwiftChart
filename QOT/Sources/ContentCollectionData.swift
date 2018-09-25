//
//  ContentData.swift
//  Pods
//
//  Created by Sam Wyndham on 06/04/2017.
//
//

import Foundation
import Freddy

struct ContentCollectionData {

    let author: String?
    let section: String
    let sortOrder: Int
    let title: String
    let layoutInfo: String?
    let searchTags: String
    let relatedContentIDs: String
    let categoryIDs: [Int]
    let thumbnailURLString: String?
    let relatedContentList: [ContentRelationIntermediary]
}

// MARK: - Parser

extension ContentCollectionData: DownSyncIntermediary {

    init(json: JSON) throws {
        self.author = try json.getItemValue(at: .author, alongPath: .nullBecomesNil)
        self.section = try json.getItemValue(at: .section)
        self.title = try json.getItemValue(at: .title)
        self.sortOrder = try json.getItemValue(at: .sortOrder)
        self.relatedContentIDs = try json.serializeString(at: .relatedContentIds)
        self.searchTags = try (json.getArray(at: .searchTags) as [String]).joined(separator: ",")
        self.categoryIDs = try json.getArray(at: .categoryIds)
        self.layoutInfo = try json.serializeString(at: .layoutInfo)
        self.thumbnailURLString = try json.getItemValue(at: .thumbnail, alongPath: .nullBecomesNil)
        self.relatedContentList = try json.getArray(at: .relatedContents)
    }
}
