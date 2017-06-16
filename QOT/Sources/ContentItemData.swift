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

    /// A comma seperated list of tabs: eg. `full,bullet`
    var tabs: String { get }

    var layoutInfo: String? { get }

    var contentID: Int { get }
}

struct ContentItemData: ContentItemDataProtocol {
    let sortOrder: Int
    let secondsRequired: Int
    let value: String
    let format: String
    let viewed: Bool
    let searchTags: String
    let tabs: String
    let layoutInfo: String?
    var contentID: Int

    init(sortOrder: Int,
         title: String,
         secondsRequired: Int,
         value: String,
         format: String,
         viewed: Bool,
         searchTags: String,
         tabs: String = "",
         layoutInfo: String?) {
            self.sortOrder = sortOrder
            self.secondsRequired = secondsRequired
            self.value = value
            self.format = format
            self.viewed = viewed
            self.searchTags = searchTags
            self.tabs = tabs
            self.layoutInfo = layoutInfo
            self.contentID = 0
    }
}

// MARK: - Parser

extension ContentItemData: JSONDecodable {

    init(json: JSON) throws {
        self.sortOrder = try json.getItemValue(at: .sortOrder)
        self.secondsRequired = try json.getItemValue(at: .secondsRequired)
        self.value = try json.serializeString(at: .value)
        self.format = try json.getItemValue(at: .format)
        self.viewed = try json.getItemValue(at: .viewed)
        self.searchTags = ContentItemData.commaSeperatedStringFromArray(in: json, at: .searchTags)
        self.tabs = ContentItemData.commaSeperatedStringFromArray(in: json, at: .tabs)
        self.layoutInfo = try json.serializeString(at: .layoutInfo)
        self.contentID = try json.getItemValue(at: .contentId)
    }

    private static func commaSeperatedStringFromArray(in json: JSON, at key: JsonKey) -> String {
        do {
            return try (json.getArray(at: key) as [String]).joined(separator: ",")
        } catch {
            return ""
        }
    }
}

extension ContentItemDataProtocol {
    func validate() throws {
        // FIXME: Implement
    }
}
