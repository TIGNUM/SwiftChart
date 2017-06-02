//
//  EKEventStatusTests.swift
//  QOT
//
//  Created by Sam Wyndham on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import XCTest
import EventKit
@testable import QOT

// As we are using these values in local and remote databases it is important that we confirm they are unchanged.
class EKEventStatusTests: XCTestCase {
    func test_rawValues_areCorrect() {
        // ☠️☠️ Think hard before modifying the following tests. ☠️☠️
        
        XCTAssertEqual(EKEventStatus.none.rawValue, 0)
        XCTAssertEqual(EKEventStatus.confirmed.rawValue, 1)
        XCTAssertEqual(EKEventStatus.tentative.rawValue, 2)
        XCTAssertEqual(EKEventStatus.canceled.rawValue, 3)
    }
}
