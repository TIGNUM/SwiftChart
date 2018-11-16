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
        statusView.isHidden = status == .done ? true : false
        firstConstraint.isActive = status == .done ? false : true
        secondConstraint.isActive = status == .done ? true: false
        layoutIfNeeded()
    }

    func bodyAttributedText(text: String,
                            font: UIFont,
                            lineSpacing: CGFloat = 10,
                            breakMode: NSLineBreakMode? = .byWordWrapping) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         font: font,
                                         lineSpacing: lineSpacing,
                                         textColor: .white,
                                         alignment: .left,
                                         lineBreakMode: breakMode)
    }
}
