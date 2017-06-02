//
//  PageEventTests.swift
//  QOT
//
//  Created by Sam Wyndham on 14/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import XCTest
@testable import QOT

class PageEventTests: XCTestCase {
    func test_init_withNonNilValues_configuresPropertiesCorrectly() {
        let pageID = PageID.launch
        let referrerPageID = PageID.mainMenu
        let associatedEntityID = 10
        
        let pageEvent = PageEvent(pageID: pageID, referrerPageID: referrerPageID, associatedEntityID: associatedEntityID)
        
        XCTAssertEqual(pageEvent.pageID, pageID.rawValue)
        XCTAssertEqual(pageEvent.referrerPageID, referrerPageID.rawValue)
        XCTAssertEqual(pageEvent.associatedEntityID, associatedEntityID)
    }
    
    func test_init_withSomeNilValues_configuresPropertiesCorrectly() {
        let pageID = PageID.launch
        
        let pageEvent = PageEvent(pageID: pageID, referrerPageID: nil, associatedEntityID: nil)
        
        XCTAssertEqual(pageEvent.pageID, pageID.rawValue)
        XCTAssertEqual(pageEvent.referrerPageID, nil)
        XCTAssertEqual(pageEvent.associatedEntityID, nil)
    }
}
