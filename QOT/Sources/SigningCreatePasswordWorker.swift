//
//  SigningCreatePasswordWorker.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCreatePasswordWorker {

    // MARK: - Properties

    private let services: Services
    let responseType: UserRegistrationCheck.ResponseType
    var userSigning: UserSigning?

    // MARK: - Init

    init(services: Services,
         userSigning: UserSigning?,
         responseType: UserRegistrationCheck.ResponseType) {
        self.services = services
        self.userSigning = userSigning
        self.responseType = responseType
    }
}

// MARK: - Public

extension SigningCreatePasswordWorker {

    func isPasswordSecure(password: String?) -> Bool {
        guard let password = password else { return false }
        var containsSpecialCharacter = false
        let setSpecial = CharacterSet.alphanumerics
        if password.rangeOfCharacter(from: setSpecial.inverted) != nil {
            containsSpecialCharacter = true
        }
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let containsCapitalCharacter = predicate.evaluate(with: password)
        return password.count >= 8 && containsSpecialCharacter == true && containsCapitalCharacter == true
    }
}
