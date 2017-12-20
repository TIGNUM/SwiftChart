//
//  GuideGreetingView.swift
//  QOT
//
//  Created by karmic on 14.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class GuideGreetingView: UIView {

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var greetingLabel: UILabel!
    var services: Services?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .pineGreen
    }

    func configure(greeting: String) {
        messageLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                     text: message,
                                                     font: Font.H5SecondaryHeadline,
                                                     textColor: .white70,
                                                     alignment: .left)
        greetingLabel.attributedText = attributedText(letterSpacing: -0.8,
                                                      text: greeting,
                                                      font: Font.H4Headline,
                                                      textColor: .white,
                                                      alignment: .left)
    }
}

// MARK: - Private

private extension GuideGreetingView {

    var message: String {
        let userName = services?.mainRealm.objects(User.self).first?.givenName ?? ""
        let welcomeMessage = Date().isBeforeNoon == true ? "Good Morning" : "Hello"

        return String(format: "%@ %@\n", welcomeMessage, userName)
    }

//    var greeting: String? {
//        if true {
//            return GuideViewModel.DefaultMessage.welcome.text(services?.contentService)
//        } else {
//            return GuideViewModel.DefaultMessage.dailyLearnPlan.text(services?.contentService)
//        }
//    }

    func attributedText(letterSpacing: CGFloat = 2,
                        text: String,
                        font: UIFont,
                        textColor: UIColor,
                        alignment: NSTextAlignment) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         letterSpacing: letterSpacing,
                                         font: font,
                                         lineSpacing: 1.4,
                                         textColor: textColor,
                                         alignment: alignment,
                                         lineBreakMode: .byWordWrapping)
    }
}
