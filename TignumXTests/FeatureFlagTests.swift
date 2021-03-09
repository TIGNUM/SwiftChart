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
    private lazy var activated: [NetworkEnvironment.Name: [Feature.Flag]] = {
        return [.DEV: [.editableNotifications],
                .INT: [.editableNotifications],
                .PUB: []]
    }()

    func testActivatedFeatureEditableNotification() {
        XCTAssertTrue(Feature.Flag.editableNotifications.isOn(activated, environment: .DEV))
        XCTAssertTrue(Feature.Flag.editableNotifications.isOn(activated, environment: .INT))
        XCTAssertFalse(Feature.Flag.editableNotifications.isOn(activated, environment: .PUB))
     }
}
