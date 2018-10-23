//
//  PartnersOverviewModel.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

struct Partners {

    enum SharingType: String {
        case toBeVision = "TOBEVISION"
        case weeklyChoices = "WEEKLYCHOICES"
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
            return [name?.first, surname?.first].compactMap { $0 }.map { String($0) }.joined()
        }

        var isValid: Bool {
            return [name, surname, email].filter { $0?.isEmpty == false }.count == 3
        }

        var isEmpty: Bool {
            let nonEmptyStrings = [name, surname, email].compactMap { $0 }.filter { $0.isEmpty == false }
            return nonEmptyStrings.isEmpty && imageURL == nil
        }

        func delete() {
            name = nil
            surname = nil
            email = nil
            imageURL = nil
            relationship = nil
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

struct PartnersLandingPage {

    enum ItemTypes: String {
        case title = "partners.landing.page.title"
        case message = "partners.landing.page.body"
        case buttonTitle = "partners.landing.page.button.title"

        var predicate: NSPredicate {
            return NSPredicate(tag: rawValue)
        }
    }

    let title: String?
    let message: String?
    let buttonTitle: String?
    let defaultProfilePicture: UIImage?

    var titleAttributedString: NSAttributedString {
        return NSAttributedString(string: (title ?? "").uppercased(),
                                  letterSpacing: -0.8,
                                  font: .H4Headline,
                                  textColor: .white,
                                  alignment: .center)
    }

    var messageAttributedString: NSAttributedString {
        return NSAttributedString(string: message ?? "",
                                  letterSpacing: 0,
                                  font: .DPText,
                                  lineSpacing: 12,
                                  textColor: .white,
                                  alignment: .center)
    }

    var buttonTitleAttributedString: NSAttributedString {
        return NSAttributedString(string: buttonTitle ?? "",
                                  letterSpacing: 1,
                                  font: .DPText,
                                  textColor: .white,
                                  alignment: .center)
    }
}
