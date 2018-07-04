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
        guard let view = R.nib.guideGreetingView.instantiate(withOwner: self).first as? GuideGreetingView else {
            fatalError("Cannot load guide view")
        }
        return view
    }

    @IBOutlet private weak var fadeView: UIView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    func configure(message: String, greeting: String, userImage: URL?) {
        greetingLabel.attributedText = attributedText(greeting)
        messageLabel.attributedText = attributedText(message)
        userImageView.kf.setImage(with: userImage)
        fadeView.alpha = 0.8
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        greetingLabel.preferredMaxLayoutWidth = greetingLabel.bounds.width
        messageLabel.preferredMaxLayoutWidth = messageLabel.bounds.width
    }
}

// MARK: - Private

private extension GuideGreetingView {

    func attributedText(_ text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text.uppercased(),
                                         letterSpacing: -0.8,
                                         font: Font.H4Headline,
                                         lineSpacing: 1.4,
                                         textColor: .white,
                                         alignment: .left,
                                         lineBreakMode: .byWordWrapping)
    }
}
