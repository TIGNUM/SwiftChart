//
//  ContentCategoryData.swift
//  Pods
//
//  Created by Sam Wyndham on 07/04/2017.
//
//

import Foundation
import Freddy

protocol ContentCategoryDataProtocol {

    var sortOrder: Int { get }

    /// Identifies what section the category is used in. e.g. "learn.strategy".
    var section: String { get }

    var title: String { get }

    var keypathID: String? { get }

    /**
     A JSON string containing layout information. eg. for the learn section
     bubbles:

     {
     radius: 0.3121,
     centerX: 0.5349,
     centerY: 0.1222
     {

     */
    var layoutInfo: String? { get }
}

struct ContentCategoryData: ContentCategoryDataProtocol {

    let sortOrder: Int
    let section: String
    let keypathID: String?
    let title: String
    let subTitle: String?
    let layoutInfo: String?
    let relatedContentIDs: [Int]
    let searchTags: String
    let categoryIDs: [Int]

    //TODO: Please remove me later.

    init(sortOrder: Int, section: String, title: String, keypathID: String? = nil, layoutInfo: String?) {
        self.sortOrder = sortOrder
        self.section = section
        self.keypathID = keypathID
        self.title = title
        self.layoutInfo = layoutInfo
        self.subTitle = nil
        self.relatedContentIDs = []
        self.searchTags = ""
        self.categoryIDs = []
    }
}

// MARK: - Parser

extension ContentCategoryData: JSONDecodable {

    init(json: JSON) throws {
        self.title = try json.getItemValue(at: .title)
        self.subTitle = try json.getItemValue(at: .subtitle, alongPath: .NullBecomesNil)
        self.sortOrder = try json.getItemValue(at: .sortOrder)
        self.section = try json.getItemValue(at: .section)
        self.relatedContentIDs = try json.getArray(at: .relatedContentIDs)
        self.searchTags = try (json.getArray(at: .searchTags) as [String]).joined(separator: ",")
        self.categoryIDs = try json.getArray(at: .categoryIDs)
        self.layoutInfo = try json[.layoutInfo]?.serializeString()
        self.keypathID = try json.getItemValue(at: .keypathID, alongPath: .NullBecomesNil)
    }
}
