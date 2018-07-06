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
        case invalid
    }

    // MARK: - Properties

    let response: String
    let message: String
    let responseType: ResponseType
    var userSigning: UserSigning?

    // MARK: - Init

    init(json: JSON) throws {
        response = try json.getItemValue(at: .responseReturnCode)
        message = try json.getItemValue(at: .message)
        var type = ResponseType.invalid
        if response == UserRegistrationCheck.ResponseType.userExist.rawValue {
            type = .userExist
        }
        if response == UserRegistrationCheck.ResponseType.codeSent.rawValue {
            type = .codeSent
        }
        if response == UserRegistrationCheck.ResponseType.codeValid.rawValue {
            type = .codeValid
        }
        if response == UserRegistrationCheck.ResponseType.userCreated.rawValue {
            type = .userCreated
        }
        if response == UserRegistrationCheck.ResponseType.codeValidNoPassword.rawValue {
            type = .codeValidNoPassword
            let userSigningJson = try json.json(at: .user)
            userSigning = try UserSigning(json: userSigningJson)

        }
        responseType = type
    }

    static func parse(_ data: Data) throws -> UserRegistrationCheck {
        return try UserRegistrationCheck(json: try JSON(data: data))
    }
}
