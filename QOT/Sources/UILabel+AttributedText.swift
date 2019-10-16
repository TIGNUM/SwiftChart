//
//  UILabel+AttributedText.swift
//  QOT
//
//  Created by Moucheg Mouradian on 09/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setAttrText(text: String,
                     font: UIFont,
                     alignment: NSTextAlignment = .natural,
                     lineSpacing: CGFloat = 13,
                     characterSpacing: CGFloat = 0,
                     color: UIColor? = nil) {
        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        let range = NSRange(location: 0, length: text.count)
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        attrString.addAttribute(.paragraphStyle, value: style, range: range)
        attrString.addAttribute(.font, value: font, range: range)
        attrString.addAttribute(.kern, value: characterSpacing, range: range)

        if let color = color {
            attrString.addAttribute(.foregroundColor, value: color, range: range)
        }

        self.attributedText = attrString
    }

    func addCharacterSpacing(_ value: CGFloat) {
        if let text = text, text.count > 0 {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.kern, value: value, range: NSRange(location: 0, length: text.count))
            attributedText = attributedString
        }
    }
}
