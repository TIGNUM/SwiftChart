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
    
    func setAttrText(text: String, font: UIFont, alignment: NSTextAlignment = .natural, lineSpacing: CGFloat = 13, characterSpacing: CGFloat = 0, color: UIColor? = nil) {
        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        let range = NSRange(location: 0, length: text.characters.count)
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

    func startBlinking(duration: CGFloat = 0.75) {
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .repeat, animations: { [unowned self] in
            self.alpha = 0
        }, completion: nil)
    }

    func stopBlinking() {
        alpha = 1
        layer.removeAllAnimations()
    }
}
