//
//  FromMyCoachMessageView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FromMyCoachMessageView: UIView {

    var isFirstView: Bool = false

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var topSeparatorView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topViewHeightConstraint: NSLayoutConstraint!

    enum Spacing: CGFloat {
        case defaultSpacing = 16
        case fromSecondViewSpacing = 50
    }

    static func instantiateFromNib() -> FromMyCoachMessageView? {
        guard let fromMyCoachMessageView = R.nib.fromMyCoachMessageView.instantiate(withOwner: self).first as? FromMyCoachMessageView else {
            log("Cannot load view: (self.Type)", level: .error)
            return nil
        }
        return fromMyCoachMessageView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstView {
            containerView.maskCorners(corners: [.bottomLeft, .bottomRight], radius: Layout.cornerRadius08)
        } else {
            containerView.corner(radius: Layout.cornerRadius08)
        }
    }

    func configure(with data: FromMyCoachMessage) {
        topViewHeightConstraint.constant = isFirstView == true ? Spacing.defaultSpacing.rawValue : Spacing.fromSecondViewSpacing.rawValue
        topSeparatorView.isHidden = isFirstView == true
        dateLabel.text = data.date
        textLabel.attributedText = formatted(text: data.text)
    }
}

private extension FromMyCoachMessageView {
    func formatted(text: String) -> NSAttributedString? {
        return NSAttributedString(string: text,
                                  letterSpacing: 0.3,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 3,
                                  textColor: .carbon60)
    }
}
