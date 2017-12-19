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

    func configure(message: String, greeting: String?) {
        backgroundColor = .pineGreen
        messageLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                     text: message,
                                                     font: Font.H5SecondaryHeadline,
                                                     textColor: .white70,
                                                     alignment: .left)
        if let greeting = greeting {
            greetingLabel.attributedText = attributedText(letterSpacing: -0.8,
                                                          text: greeting,
                                                          font: Font.H4Headline,
                                                          textColor: .white,
                                                          alignment: .left)
        }
    }
}

// MARK: - Private

private extension GuideGreetingView {

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
