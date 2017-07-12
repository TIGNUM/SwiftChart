//
//  ContentCategoryData.swift
//  Pods
//
//  Created by Sam Wyndham on 07/04/2017.
//
//

import Foundation
import Freddy

struct ContentCategoryData {

    let sortOrder: Int
    let title: String
    let layoutInfo: String?
    let searchTags: String

    //TODO: Please remove me later.

    init(sortOrder: Int, title: String, layoutInfo: String?) {
        self.sortOrder = sortOrder
        self.title = title
        self.layoutInfo = layoutInfo
        self.searchTags = ""
    }
}

// MARK: - Parser

extension ContentCategoryData: DownSyncIntermediary {

    init(json: JSON) throws {
        self.title = try json.getItemValue(at: .title)
        self.sortOrder = try json.getItemValue(at: .sortOrder)
        self.searchTags = try (json.getArray(at: .searchTags) as [String]).joined(separator: ",")
        self.layoutInfo = try json.serializeString(at: .layoutInfo)
    }
}
