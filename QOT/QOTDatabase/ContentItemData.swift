//
//  ContentItemData.swift
//  Pods
//
//  Created by Sam Wyndham on 07/04/2017.
//
//

import Foundation
import Freddy

protocol ContentItemDataProtocol {

    var sortOrder: Int { get }

    var title: String { get }

    var secondsRequired: Int { get }

    /**
     This string might represent a URL, text or even json depending on the 
     format.
    */
    var value: String { get }

    var format: String { get }

    /**
     When the content was last viewed or nil if never.

     We will set this locally but notify the server though page tracking. This 
     may be overriden during sync.
    */
    var viewed: Bool { get }

    /// A comma seperated list of tags: eg. `blog,health`
    var searchTags: String { get }

    var layoutInfo: String? { get }

    var contentID: Int { get }
}

struct ContentItemData: ContentItemDataProtocol {
    let sortOrder: Int
    let title: String
    let secondsRequired: Int
    let value: String
    let format: String
    let viewed: Bool
    let searchTags: String
    let layoutInfo: String?
    var contentID: Int

    init(sortOrder: Int,
         title: String,
         secondsRequired: Int,
         value: String,
         format: String,
         viewed: Bool,
         searchTags: String,
         layoutInfo: String?) {
            self.sortOrder = sortOrder
            self.title = title
            self.secondsRequired = secondsRequired
            self.value = value
            self.format = format
            self.viewed = viewed
            self.searchTags = searchTags
            self.layoutInfo = layoutInfo
            self.contentID = 0
    }
}

// MARK: - Parser

extension ContentItemData: JSONDecodable {

    init(json: JSON) throws {
        self.sortOrder = try json.getItemValue(at: .sortOrder)
        self.title = try json.getItemValue(at: .title)
        self.secondsRequired = try json.getItemValue(at: .secondsRequired)
        self.value = try json.makeJSONDictionary(json.getDictionary(at: JsonKey.value.value)).serializeString()
        self.format = try json.getItemValue(at: .format)
        self.viewed = try json.getItemValue(at: .viewed)
        self.searchTags = try (json.getArray(at: .searchTags) as [String]).joined(separator: ",")
        self.layoutInfo = try json[.layoutInfo]?.serializeString()
        self.contentID = try json.getItemValue(at: .categoryID)
    }
}

extension ContentItemDataProtocol {
    func validate() throws {
        // FIXME: Implement
    }
}
