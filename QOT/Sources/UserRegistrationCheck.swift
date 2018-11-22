//
//  UserEmailCheck.swift
//  QOT
//
//  Created by karmic on 08.06.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserRegistrationCheck {

    enum ResponseType: String {
        case userExist = "USER_EXIST"
        case codeSent = "VERIFICATIONCODE_SENT"
        case codeValid = "VERIFICATIONCODE_VALID"
        case codeValidNoPassword = "VERIFICATIONCODE_VALID_NO_PASSWORD"
        case userCreated = "USER_CREATED"
        case invalidAppVersion = "INVALID_APP_VERSION"
        case invalid
    }

    // MARK: - Properties

    let response: String
    let message: String
    let responseType: ResponseType
    var userSigning: UserSigning?
    var downloadLink: String?
    var validAppScheme: String?

    // MARK: - Init

    init(json: JSON) throws {
        response = try json.getItemValue(at: .responseReturnCode)
        message = try json.getItemValue(at: .message)
        var type = ResponseType(rawValue: response)
        switch type {
        case .userExist?, .codeSent?, .codeValid?, .userCreated?:
            break
        case .codeValidNoPassword?:
            let userSigningJson = try json.json(at: .user)
            userSigning = try UserSigning(json: userSigningJson)
        case .invalidAppVersion?:
            validAppScheme = try json.getItemValue(at: .validAppScheme)
            downloadLink = try json.getItemValue(at: .iosDownloadLink)
        default:
            type = .invalid
        }
        responseType = type ?? .invalid
    }

    static func parse(_ data: Data) throws -> UserRegistrationCheck {
        return try UserRegistrationCheck(json: try JSON(data: data))
    }
}
