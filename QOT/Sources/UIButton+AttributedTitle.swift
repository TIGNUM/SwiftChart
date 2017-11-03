//
//  UIButton+AttributedTitle.swift
//  QOT
//
//  Created by Moucheg Mouradian on 11/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func prepareAndSetTitleAttributes(text: String, font: UIFont, color: UIColor, for state: UIControlState) {
        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 13
        attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.count))
        attrString.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.count))
        attrString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attrString, for: state)
    }
}
