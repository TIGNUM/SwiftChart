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
    
    func prepareAndSetTextAttributes(text: String, font: UIFont, alignment: NSTextAlignment = .natural, lineSpacing: CGFloat = 13, characterSpacing: CGFloat = 0) {
        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: text.characters.count))
        attrString.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: text.characters.count))
        attrString.addAttribute(NSKernAttributeName, value: characterSpacing, range: NSRange(location: 0, length: text.characters.count))
        self.attributedText = attrString
    }
}
