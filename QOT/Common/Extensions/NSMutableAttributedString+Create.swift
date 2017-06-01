//
//  NSMutableAttributedString+Create.swift
//  QOT
//
//  Created by karmic on 01.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    convenience init(
        string: String,
        letterSpacing: CGFloat = 1,
        font: UIFont,
        lineSpacing: CGFloat = 0,
        textColor: UIColor = .white,
        alignment: NSTextAlignment = .left) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = alignment
            let attributes: [String: Any] = [
                NSForegroundColorAttributeName: textColor,
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: font,
                NSKernAttributeName: letterSpacing
            ]

            self.init(string: string, attributes: attributes)
    }
}
