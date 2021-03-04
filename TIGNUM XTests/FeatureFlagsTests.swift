//
//  FeatureFlagsTests.swift
//  TIGNUM XTests
//
//  Created by Anais Plancoulaine on 04.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import XCTest
import qot_dal
@testable import TIGNUM_X

class FeatureFlagsTests: XCTestCase {

    func testIsFeatureActivated() {
        let currentEnvironment = NetworkEnvironment().currentScheme
        let featureFlag = FeatureFlags()
        XCTAssertTrue(featureFlag.isFeatureActivated(feature: .customizableNotifications,
                                                     environment: currentEnvironment))
    }
}
