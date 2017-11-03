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

// MARK: - Attributed Button Title - Charts SegmentedView

extension String {

    func attrString(_ selected: Bool?) -> NSAttributedString {
        let color: UIColor = selected == true ? .white : .white30
        let attrString = NSMutableAttributedString(string: self)
        let style = NSMutableParagraphStyle()
        let range = NSRange(location: 0, length: count)
        style.alignment = .center
        attrString.addAttribute(.paragraphStyle, value: style, range: range)
        attrString.addAttribute(.font, value: Font.H7Tag, range: range)
        attrString.addAttribute(.kern, value: 2, range: range)
        attrString.addAttribute(.foregroundColor, value: color, range: range)

        return attrString
    }
}

// MARK: - Chart Labels

extension String {

    func weekNumbers() -> [String] {
        var weekNumbers = [String]()
        var currentWeekNumber = Calendar.sharedUTC.component(.weekOfYear, from: Date())

        for _ in 0 ..< 4 {
            currentWeekNumber = currentWeekNumber - 1

            if currentWeekNumber <= 0 {
                currentWeekNumber = 52
            }

            weekNumbers.append(String(format: "%d", currentWeekNumber))
        }

        return weekNumbers.reversed()
    }
}
