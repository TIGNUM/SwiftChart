//
//  String+Extensions.swift
//  QOT
//
//  Created by Moucheg Mouradian on 08/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

        return boundingBox.width
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont, characterSpacing: CGFloat? = nil) -> CGFloat {

        var attributes: [String: Any] = [:]
        if let characterSpacing = characterSpacing {
            attributes[NSKernAttributeName] = characterSpacing
        }

        attributes[NSFontAttributeName] = font

        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return boundingBox.height
    }
}
