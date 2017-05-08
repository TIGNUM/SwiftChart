//
//  ContentItemData.swift
//  Pods
//
//  Created by Sam Wyndham on 07/04/2017.
//
//

import Foundation

public protocol ContentItemDataProtocol {

    var sortOrder: Int { get }

    var title: String { get }

    var secondsRequired: Int { get }

    /**
     This string might represent a URL, text or even json depending on the 
     format.
    */
    var value: String { get }

    var format: Int8 { get }

    /**
     When the content was last viewed or nil if never.

     We will set this locally but notify the server though page tracking. This 
     may be overriden during sync.
    */
    var viewAt: Date? { get }

    /// A comma seperated list of tags: eg. `blog,health`
    var searchTags: String { get }

    var layoutInfo: String? { get }
}

public struct ContentItemData: ContentItemDataProtocol {

    public let sortOrder: Int
    public let title: String
    public let secondsRequired: Int
    public let value: String
    public let format: Int8
    public let viewAt: Date?
    public let searchTags: String
    public var layoutInfo: String?

    public init(sortOrder: Int, title: String, secondsRequired: Int, value: String, format: Int8, viewAt: Date?, searchTags: String, layoutInfo: String?) {
        self.sortOrder = sortOrder
        self.title = title
        self.secondsRequired = secondsRequired
        self.value = value
        self.format = format
        self.viewAt = viewAt
        self.searchTags = searchTags
        self.layoutInfo = layoutInfo
    }

}

extension ContentItemDataProtocol {
    func validate() throws {
        // FIXME: Implement
    }
}
