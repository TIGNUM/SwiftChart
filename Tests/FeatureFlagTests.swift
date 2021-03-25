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
    private lazy var environment = Environment()

    func testEditableNotification() {
        switch environment.current {
        case .DEV,
             .INT:
            XCTAssertTrue(Feature.Flag.editableNotifications.isOn)
        case .PUB:
            XCTAssertTrue(!Feature.Flag.editableNotifications.isOn)
        }
     }

    func testOnboardingSurvey() {
        switch environment.current {
        case .DEV,
             .INT:
            XCTAssertTrue(Feature.Flag.onboardingSurvey.isOn)
        case .PUB:
            XCTAssertTrue(!Feature.Flag.onboardingSurvey.isOn)
        }
    }
}
