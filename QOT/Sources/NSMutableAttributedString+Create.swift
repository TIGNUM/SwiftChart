//
//  NSMutableAttributedString+Create.swift
//  QOT
//
//  Created by karmic on 01.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import BonMot

extension NSAttributedString {

    convenience init(string: String,
                     letterSpacing: CGFloat = 1,
                     font: UIFont,
                     lineSpacing: CGFloat = 0,
                     textColor: UIColor = .white,
                     alignment: NSTextAlignment = .left,
                     lineBreakMode: NSLineBreakMode? = nil) {
        let attributes = Attributes(letterSpacing: letterSpacing,
                                    font: font,
                                    lineSpacing: lineSpacing,
                                    textColor: textColor,
                                    alignment: alignment,
                                    lineBreakMode: lineBreakMode)
        self.init(string: string, attributes: attributes)
    }

    static func makeAttributes(letterSpacing: CGFloat = 1,
                               font: UIFont,
                               lineSpacing: CGFloat = 0,
                               textColor: UIColor = .white,
                               alignment: NSTextAlignment = .left,
                               lineBreakMode: NSLineBreakMode? = nil) -> [NSAttributedStringKey: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        return [
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle,
            .font: font,
            .kern: letterSpacing
        ]
    }
}

func Attributes(letterSpacing: CGFloat = 1,
               font: UIFont,
               lineSpacing: CGFloat = 0,
               textColor: UIColor = .white,
               alignment: NSTextAlignment = .left,
               lineBreakMode: NSLineBreakMode? = nil) -> [NSAttributedStringKey: Any] {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.alignment = alignment
    if let lineBreakMode = lineBreakMode {
        paragraphStyle.lineBreakMode = lineBreakMode
    }
    return [
        .foregroundColor: textColor,
        .paragraphStyle: paragraphStyle,
        .font: font,
        .kern: letterSpacing
    ]
}

enum Style {
    case postTitle(String, UIColor)
    case secondaryTitle(String, UIColor)
    case subTitle(String, UIColor)
    case headline(String, UIColor)
    case headlineSmall(String, UIColor)
    case navigationTitle(String, UIColor)
    case tag(String, UIColor)
    case tagTitle(String, UIColor)
    case paragraph(String, UIColor)
    case qoute(String, UIColor)
    case article(String, UIColor)
    case mediaDescription(String, UIColor)
    case question(String, UIColor)
    case sub(String, UIColor)
    case num(String, UIColor)
    case sector(String, UIColor)

    private var font: UIFont {
        switch self {
        case .postTitle: return .H1MainTitle
        case .secondaryTitle: return .H2SecondaryTitle
        case .subTitle: return .H3Subtitle
        case .headline: return .H4Headline
        case .headlineSmall: return .H5SecondaryHeadline
        case .navigationTitle: return .H6NavigationTitle
        case .tag: return .H7Tag
        case .tagTitle: return .H8Title
        case .paragraph: return .H7Title
        case .qoute: return .Qoute
        case .article: return .ApercuRegular15
        case .mediaDescription: return .DPText
        case .question: return .H9Title
        case .sub: return .H8Subtitle
        case .num: return .H0Number
        case .sector: return .H7SectorTitle
        }
    }

    private func stringStyle(color: UIColor, lineSpacing: CGFloat, lineHeight: CGFloat, alignment: NSTextAlignment = .left) -> StringStyle {
        return StringStyle(
            .font(self.font),
            .color(color),
            .lineSpacing(lineSpacing),
            .alignment(alignment),
            .lineHeightMultiple(lineHeight),
            .numberSpacing(.proportional),
            .hyphenationFactor(0.3)
        )
    }

    func attributedString(lineSpacing: CGFloat = 1, lineHeight: CGFloat = 1, alignment: NSTextAlignment = .left) -> NSAttributedString {
        switch self {
        case .postTitle(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .secondaryTitle(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .subTitle(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .headline(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .headlineSmall(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .navigationTitle(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .tag(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .tagTitle(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .paragraph(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .qoute(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: .right))
        case .article(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        case .mediaDescription(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: .left))
        case .question(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: .center))
        case .sub(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: .center))
        case .num(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: .center))
        case .sector(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, lineHeight: lineHeight, alignment: alignment))
        }
    }
}
