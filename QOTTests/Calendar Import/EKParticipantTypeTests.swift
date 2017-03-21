//
//  EKParticipantTypeTests.swift
//  QOT
//
//  Created by Sam Wyndham on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import XCTest
import EventKit
@testable import QOT

// As we are using these values in local and remote databases it is important that we confirm they are unchanged.
class EKParticipantTypeTests: XCTestCase {
    func test_rawValues_areCorrect() {
        // ☠️☠️ Think hard before modifying the following tests. ☠️☠️
        
        XCTAssertEqual(EKParticipantType.unknown.rawValue, 0)
        XCTAssertEqual(EKParticipantType.person.rawValue, 1)
        XCTAssertEqual(EKParticipantType.room.rawValue, 2)
        XCTAssertEqual(EKParticipantType.resource.rawValue, 3)
        XCTAssertEqual(EKParticipantType.group.rawValue, 4)
    }
}
