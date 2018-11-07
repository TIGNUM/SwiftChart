//
//  UITableViewCell+Extensions.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 05.11.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension UITableViewCell {

    func syncStatusView(with status: Guide.Item.Status,
                        for statusView: UIView,
                        firstConstraint: NSLayoutConstraint,
                        secondConstraint: NSLayoutConstraint) {
        if status == .done {
            statusView.isHidden = true
            firstConstraint.isActive = false
            secondConstraint.isActive = true
            layoutIfNeeded()
        }
    }

    func bodyAttributedText(text: String,
                            font: UIFont,
                            lineSpacing: CGFloat = 1.4) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         font: font,
                                         lineSpacing: lineSpacing,
                                         textColor: .white,
                                         alignment: .left,
                                         lineBreakMode: .byWordWrapping)
    }
}
