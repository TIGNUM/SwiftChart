//
//  AuthTokenValidatorTests.swift
//  QOTTests
//
//  Created by Sam Wyndham on 02/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import XCTest
import JWT

@testable import QOT

let token = "eyJhbGciOiJIUzI1NiJ9.eyJ0aWdab25lQ29kZSI6ImV1IiwidGlnTGFzdG5hbWUiOiJXeW5kaGFtIiwic3ViIjoicy53eW5kaGFtQHRpZ251bS5jb20iLCJ0aWdVc2VybmFtZSI6InMud3luZGhhbUB0aWdudW0uY29tIiwiaXNzIjoiVGlnbnVtIEdtYkgiLCJ0aWdGaXJzdG5hbWUiOiJTYW0iLCJ0aWdFbXBsb3llZUlkIjpudWxsLCJ0aWdVc2VySWQiOjEwMDAwNCwidGlnUm9sZXMiOlsiRk9VTkRBVElPTiIsIlFPVCJdLCJ0aWdab25lSWQiOjEwMDEsImV4cCI6MTUxOTkyNDk2NiwiaWF0IjoxNTE5ODk2MTY2LCJqdGkiOiJzLnd5bmRoYW1AdGlnbnVtLmNvbSJ9.1au_FVEwcm65xZ0OCR2gZnDpv5eIJ0hSWnZ_c3-oOKA"

let tokenExpiry: Date = {
    let claims: ClaimSet = try! JWT.decode(token, algorithm: .none, verify: false)
    return claims.expiration!
}()

let tenSecondsLeeway = TimeInterval(10)

class AuthTokenValidatorTests: XCTestCase {

    let sut = AuthTokenValidator(expirationLeeway: tenSecondsLeeway)

    func test_isValid_withExpiredToken_returnsFalse() {
        let nineSecondsBeforeExpiration = tokenExpiry.addingTimeInterval(-TimeInterval(9))

        XCTAssertFalse(sut.isValid(token: token, now: nineSecondsBeforeExpiration))
    }

    func test_isValid_withNonExpiredToken_returnsTrue() {
        let elevenSecondsBeforeExpiration = tokenExpiry.addingTimeInterval(-TimeInterval(11))

        XCTAssertTrue(sut.isValid(token: token, now: elevenSecondsBeforeExpiration))
    }
}
