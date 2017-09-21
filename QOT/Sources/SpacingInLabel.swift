//
//  SpacingInLabel.swift
//  QOT
//
//  Created by tignum on 6/6/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addCharactersSpacing(spacing: CGFloat, text: String, uppercased: Bool = false) {
        var text = text
        if uppercased == true {
            text = text.uppercased()
        }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: text.characters.count))
        self.attributedText = attributedString
    }
}
