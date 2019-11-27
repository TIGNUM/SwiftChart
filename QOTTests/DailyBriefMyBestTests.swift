//
//  DailyBriefMyBestTests.swift
//  QOTTests
//
//  Created by Dominic Frazer Imregh on 05/11/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import XCTest
@testable import QOT

class DailyBriefMyBestTests: XCTestCase {

    override func setUp() {
        UserDefault.myBestDate.setObject(nil)
        UserDefault.myBestText.setObject(nil)
    }

    func testTextStaysTheSameOnTheSameDay() {
        let text1 = "Text 1"
        let text2 = "Text 2"
        let today1 = Date()

        let result1 = DailyBriefAtMyBestWorker().storedText(text1, today: today1)
        XCTAssertEqual(text1, result1)

        let result2 = DailyBriefAtMyBestWorker().storedText(text2, today: today1)
        XCTAssertEqual(text1, result2)
    }

    func testTextChangesOnTheNextDay() {
        let text1 = "Text 1"
        let text2 = "Text 2"
        let today1 = Date()
        let today2 = Date().addingTimeInterval(24 * 60 * 60)

        let result1 = DailyBriefAtMyBestWorker().storedText(text1, today: today1)
        XCTAssertEqual(text1, result1)

        let result2 = DailyBriefAtMyBestWorker().storedText(text2, today: today2)
        XCTAssertEqual(text2, result2)
    }

}
