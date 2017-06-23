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
        }
    }

    private func stringStyle(color: UIColor, lineSpacing: CGFloat, alignment: NSTextAlignment = .left) -> StringStyle {
        return StringStyle(
            .font(self.font),
            .color(color),
            .lineSpacing(lineSpacing),
            .alignment(alignment)
        )
    }

    func attributedString(lineSpacing: CGFloat = 1) -> NSAttributedString {
        switch self {
        case .postTitle(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing))
        case .secondaryTitle(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing))
        case .subTitle(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing))
        case .headline(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing))
        case .headlineSmall(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing))
        case .navigationTitle(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing))
        case .tag(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing))
        case .paragraph(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing))
        case .qoute(let string, let color):
            return string.styled(with: stringStyle(color: color, lineSpacing: lineSpacing, alignment: .right))
        }
    }
}
