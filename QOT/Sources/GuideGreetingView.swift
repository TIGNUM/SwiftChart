//
//  GuideGreetingView.swift
//  QOT
//
//  Created by karmic on 14.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class GuideGreetingView: UIView {

    static func instantiateFromNib() -> GuideGreetingView {
        let nibName = "GuideGreetingView"
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: [:])?[0] as? GuideGreetingView else {
            fatalError("Cannot load guide view")
        }
        return view
    }

    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    func configure(message: String, greeting: String) {
        greetingLabel.attributedText = attributedText(letterSpacing: -0.8,
                                                     text: greeting.uppercased(),
                                                     font: Font.H4Headline,
                                                     textColor: .white,
                                                     alignment: .left)
        messageLabel.attributedText = attributedText(letterSpacing: -0.8,
                                                      text: message.uppercased(),
                                                      font: Font.H4Headline,
                                                      textColor: .white,
                                                      alignment: .left)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        greetingLabel.preferredMaxLayoutWidth = greetingLabel.bounds.width
        messageLabel.preferredMaxLayoutWidth = messageLabel.bounds.width
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
