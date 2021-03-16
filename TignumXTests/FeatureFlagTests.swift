//
//  FeatureFlagTests.swift
//  TignumXTests
//
//  Created by karmic on 06.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import XCTest
import qot_dal
@testable import TIGNUM_X

class FeatureFlagTests: XCTestCase {
    func testEditableNotification() {
        let environment = Environment()
        switch environment.current {
        case .DEV,
             .INT:
            XCTAssertTrue(Feature.Flag.editableNotifications.isOn == true)
            XCTAssertFalse(Feature.Flag.editableNotifications.isOn == false)
        case .PUB:
            XCTAssertFalse(Feature.Flag.editableNotifications.isOn == true)
            XCTAssertTrue(Feature.Flag.editableNotifications.isOn == false)
        }
     }
}
