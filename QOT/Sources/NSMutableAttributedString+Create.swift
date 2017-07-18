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

extension NSMutableAttributedString {

    convenience init(
        string: String,
        letterSpacing: CGFloat = 1,
        font: UIFont,
        lineSpacing: CGFloat = 0,
        textColor: UIColor = .white,
        alignment: NSTextAlignment = .left,
        lineBreakMode: NSLineBreakMode? = nil) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = alignment
            if let lineBreakMode = lineBreakMode {
                paragraphStyle.lineBreakMode = lineBreakMode
            }
            let attributes: [String: Any] = [
                NSForegroundColorAttributeName: textColor,
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: font,
                NSKernAttributeName: letterSpacing
            ]

            self.init(string: string, attributes: attributes)
    }
}

enum Style {
    case postTitle(String, UIColor)
    case secondaryTitle(String, UIColor)
    case subTitle(String, UIColor)
    case headline(String, UIColor)
    case headlineSmall(String, UIColor)
    case navigationTitle(String, UIColor)
    case tag(String, UIColor)
    case paragraph(String, UIColor)
    case qoute(String, UIColor)
    case article(String, UIColor)
    case mediaDescription(String, UIColor)
    case question(String, UIColor)
    case sub(String, UIColor)
    case num(String, UIColor)

    private var font: UIFont {
        switch self {
        case .postTitle: return Font.H1MainTitle
        case .secondaryTitle: return Font.H2SecondaryTitle
        case .subTitle: return Font.H3Subtitle
        case .headline: return Font.H4Headline
        case .headlineSmall: return Font.H5SecondaryHeadline
        case .navigationTitle: return Font.H6NavigationTitle
        case .tag: return Font.H7Tag
        case .paragraph: return Font.H7Title
        case .qoute: return Font.Qoute
        case .article: return Font.DPText
        case .mediaDescription: return Font.DPText
        case .question: return Font.H9Title
        case .sub: return Font.H8Subtitle
        case .num: return Font.H0Number
        }
    }

    private func stringStyle(color: UIColor, lineSpacing: CGFloat, lineHeight: CGFloat, alignment: NSTextAlignment = .left) -> StringStyle {
        return StringStyle(
            .font(self.font),
            .color(color),
            .lineSpacing(lineSpacing),
            .alignment(alignment),
            .lineHeightMultiple(lineHeight),
            .numberSpacing(.proportional)
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
        }
    }
}
