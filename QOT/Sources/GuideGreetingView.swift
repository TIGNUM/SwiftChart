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

    func configure(_ item: Guide.Item? = nil) {
        messageLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                     text: message,
                                                     font: Font.H5SecondaryHeadline,
                                                     textColor: .white70,
                                                     alignment: .left)
        greetingLabel.attributedText = attributedText(letterSpacing: -0.8,
                                                      text: text(item),
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

        return String(format: "%@ %@,\n", welcomeMessage, userName)
    }

    func text(_ item: Guide.Item?) -> String {
        guard let contentService = services?.contentService else { return "" }

        if services?.guideService.guideSections().count == 1 {
            if ((services?.guideService.guideSections().first?.items.filter { $0.completedAt != nil })?.isEmpty)! {
                return GuideViewModel.Message.welcome.text(contentService)
            }
        }

        if let item = item, item.isDailyPrep == true && item.isDailyPrepCompleted == false {
            if item.greeting.isEmpty == false {
                return item.greeting
            } else {
                return GuideViewModel.Message.dailyPrep.text(contentService)
            }
        }

        if let greeting = item?.greeting {
            return greeting
        } else {
            return GuideViewModel.Message.dailyLearnPlan.text(contentService)
        }
    }

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
