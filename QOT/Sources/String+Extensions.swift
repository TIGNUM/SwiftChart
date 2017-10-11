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
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return boundingBox.width
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont, characterSpacing: CGFloat? = nil) -> CGFloat {
        var attributes: [NSAttributedStringKey: Any] = [:]
        attributes[.kern] = characterSpacing
        attributes[.font] = font
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return boundingBox.height
    }

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    func makingTwoLines() -> String {
        guard rangeOfCharacter(from: .newlines) == nil else {
            return self
        }

        guard let regex = try? NSRegularExpression(pattern: " ", options: .caseInsensitive) else {
            fatalError("invalid regex")
        }

        let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))

        if results.count == 0 {
            return self
        }

        let minIndex = utf16.count / 2
        var candidate = results[0]
        for result in results.dropFirst() {
            if abs(minIndex - result.range.location) < abs(minIndex - candidate.range.location) {
                candidate = result
            }
        }

        return (self as NSString).replacingCharacters(in: candidate.range, with: "\n") as String
    }

    /// Returns nil if string contains only whitespace or new line characters
    var nilled: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
