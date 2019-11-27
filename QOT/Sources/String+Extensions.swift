//
//  String+Extensions.swift
//  QOT
//
//  Created by Moucheg Mouradian on 08/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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

    var isTrimmedTextEmpty: Bool? {
        return self.trimmingCharacters(in: .newlines).components(separatedBy: .whitespaces).first?.isEmpty
    }

    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    var isValidName: Bool {
        let nameRegex = "[A-Za-z0-9 ,.'-]{1,512}"
        let cleanString = self.folding(options: .diacriticInsensitive, locale: .current)
        if let range = cleanString.range(of: nameRegex, options: .regularExpression, range: nil, locale: nil),
            NSRange(range, in: cleanString).length == cleanString.lengthOfBytes(using: .utf8) {
            return true
        }

        return false
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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
