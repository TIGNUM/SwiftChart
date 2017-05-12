//
//  ContentData.swift
//  Pods
//
//  Created by Sam Wyndham on 06/04/2017.
//
//

import Foundation

protocol ContentCollectionDataProtocol {

    var sortOrder: Int { get }

    var title: String { get }

    /** 
     A JSON string containing layout information. e.g. For the prepare
     section accordian a group title is necessary:

         {
           groupTitle: "PRE-TRAVEL"
         }
    */
    var layoutInfo: String? { get }

    /// A comma seperated list of tags: eg. `blog,health`
    var searchTags: String { get }

    /// A JSON array of related `ContentCollection` `remoteID`s.
    var relatedContent: String? { get }
}

struct ContentCollectionData: ContentCollectionDataProtocol {

    let sortOrder: Int
    let title: String
    let layoutInfo: String?
    let searchTags: String
    let relatedContent: String?

    init(sortOrder: Int, title: String, layoutInfo: String?, searchTags: String, relatedContent: String?) {
        self.sortOrder = sortOrder
        self.title = title
        self.layoutInfo = layoutInfo
        self.searchTags = searchTags
        self.relatedContent = relatedContent
    }
}
