//
//  ShareModels.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct Partners {

    enum SharingType: String {
        case toBeVision = "TOBEVISION"
        case weeklyChoices = "WEEKLYCHOICES"
        case invite = "INVITE_PARTNER"
    }

    class Partner: Equatable {
        let localID: String
        var name: String?
        var surname: String?
        var relationship: String?
        var email: String?
        var imageURL: URL?

        init(localID: String,
             name: String?,
             surname: String?,
             relationship: String?,
             email: String?,
             imageURL: URL?) {
            self.localID = localID
            self.name = name
            self.surname = surname
            self.relationship = relationship
            self.email = email
            self.imageURL = imageURL
        }

        var initials: String {
            return [name?.first, surname?.first].flatMap { $0 }.map { String($0) }.joined()
        }

        public static func == (lhs: Partner, rhs: Partner) -> Bool {
            return lhs.localID == rhs.localID
                && lhs.name == rhs.name
                && lhs.surname == rhs.surname
                && lhs.relationship == rhs.relationship
                && lhs.email == rhs.email
                && lhs.imageURL == rhs.imageURL
        }
    }
}
