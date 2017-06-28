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

    let section: String
    let sortOrder: Int
    let title: String
    let layoutInfo: String?
    let searchTags: String
    let relatedContentIDs: String
    let categoryIDs: [Int]
    let thumbnailURLString: String?

    init(section: String, sortOrder: Int, title: String, layoutInfo: String?, searchTags: String, relatedContent: String?, thumbnailURL: String? = nil) {
        self.section = section
        self.sortOrder = sortOrder
        self.title = title
        self.layoutInfo = layoutInfo
        self.searchTags = searchTags
        self.relatedContentIDs = "[]"
        self.categoryIDs = []
        self.thumbnailURLString = thumbnailURL
    }
}

// MARK: - Parser

extension ContentCollectionData: JSONDecodable {

    init(json: JSON) throws {
        self.section = try json.getItemValue(at: .section)
        self.title = try json.getItemValue(at: .title)
        self.sortOrder = try json.getItemValue(at: .sortOrder)
        self.relatedContentIDs = try json.serializeString(at: .relatedContentIds)
        self.searchTags = try (json.getArray(at: .searchTags) as [String]).joined(separator: ",")
        self.categoryIDs = try json.getArray(at: .categoryIds)
        self.layoutInfo = try json.serializeString(at: .layoutInfo)
        self.thumbnailURLString = try json.getItemValue(at: .thumbnail, alongPath: .NullBecomesNil)
    }
}
