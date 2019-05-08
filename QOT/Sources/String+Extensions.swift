//
//  String+Extensions.swift
//  QOT
//
//  Created by Moucheg Mouradian on 08/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension String {

    func size(with font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
    }

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

    var isTrimmedTextEmpty: Bool? {
        return self.trimmingCharacters(in: .newlines).components(separatedBy: .whitespaces).first?.isEmpty
    }

    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {

    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber &&
                    res.range.location == 0 &&
                    res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }

    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
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
        attrString.addAttribute(.font, value: UIFont.H7Tag, range: range)
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

// MARK: - WhatsHot regex

extension String {

    static func getString(for regex: String, in text: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.count > 0 ? nsString.substring(with: results[0].range) : ""
        } catch {
            log("invalid regex: \(error.localizedDescription)")
            return ""
        }
    }

    static func matches(for regex: String, in text: String) -> [NSRange] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { $0.range }
        } catch {
            log("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

extension String {
    func convertHtml() -> NSAttributedString? {
        let htmlData = NSString(string: self).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                              options: options,
                                                              documentAttributes: nil)
        return attributedString
    }
}
