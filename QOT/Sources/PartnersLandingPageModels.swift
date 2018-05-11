//
//  PartnersLandingPageModels.swift
//  QOT
//
//  Created by karmic on 09.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

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
                                  font: .simpleFont(ofSize: 20),
                                  textColor: .white,
                                  alignment: .center)
    }

    var messageAttributedString: NSAttributedString {
        return NSAttributedString(string: message ?? "",
                                  letterSpacing: 0,
                                  font: .bentonBookFont(ofSize: 16),
                                  lineSpacing: 12,
                                  textColor: .white,
                                  alignment: .center)
    }

    var buttonTitleAttributedString: NSAttributedString {
        return NSAttributedString(string: buttonTitle ?? "",
                                  letterSpacing: 1,
                                  font: .bentonBookFont(ofSize: 16),
                                  textColor: .white,
                                  alignment: .center)
    }
}
