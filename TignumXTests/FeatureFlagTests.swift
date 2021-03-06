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
    func testActivatedFeatureEditableNotification() {
        XCTAssertTrue(Feature.Flag.editableNotifications.isOn(for: .DEV))
        XCTAssertTrue(Feature.Flag.editableNotifications.isOn(for: .INT))
        XCTAssertFalse(Feature.Flag.editableNotifications.isOn(for: .PUB))
     }
}
