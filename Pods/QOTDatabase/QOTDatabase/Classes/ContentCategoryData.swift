//
//  ContentCategoryData.swift
//  Pods
//
//  Created by Sam Wyndham on 07/04/2017.
//
//

import Foundation

public protocol ContentCategoryDataProtocol {

    var sortOrder: Int { get }

    /// Identifies what section the category is used in. e.g. "learn.strategy".
    var section: String { get }

    var title: String { get }

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

public struct ContentCategoryData: ContentCategoryDataProtocol {

    public let sortOrder: Int
    public let section: String
    public let title: String
    public let layoutInfo: String?

    public init(sortOrder: Int, section: String, title: String, layoutInfo: String?) {
        self.sortOrder = sortOrder
        self.section = section
        self.title = title
        self.layoutInfo = layoutInfo
    }
}
