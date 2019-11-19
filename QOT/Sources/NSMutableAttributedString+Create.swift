//
//  NSMutableAttributedString+Create.swift
//  QOT
//
//  Created by karmic on 01.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

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
    case postTitle(String)
    case secondaryTitle(String)
    case subTitle(String)
    case headline(String)
    case headlineSmall(String)
    case navigationTitle(String)
    case tag(String)
    case tagTitle(String)
    case paragraph(String)
    case quote(String)
    case article(String)
    case mediaDescription(String)
    case question(String)
    case sub(String)
    case num(String)
    case sector(String)

    func attributedString(lineSpacing: CGFloat? = nil, lineHeight: CGFloat? = nil) -> NSAttributedString {
        switch self {
        case .postTitle(let string):
            return ThemeText.articlePostTitle.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .secondaryTitle(let string):
            return ThemeText.articleSecondaryTitle.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .subTitle(let string):
            return ThemeText.articleSubTitle.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .headline(let string):
            return ThemeText.articleHeadline.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .headlineSmall(let string):
            return ThemeText.articleHeadlineSmall.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .navigationTitle(let string):
            return ThemeText.articleNavigationTitle.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .tag(let string):
            return ThemeText.articleTag.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .tagTitle(let string):
            return ThemeText.articleTagTitle.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .paragraph(let string):
            return ThemeText.articleParagraph.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .quote(let string):
            return ThemeText.articleQuote.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .article(let string):
            return ThemeText.article.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .mediaDescription(let string):
            return ThemeText.articleMediaDescription.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .question(let string):
            return ThemeText.articleQuestion.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .sub(let string):
            return ThemeText.articleSub.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .num(let string):
            return ThemeText.articleNum.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .sector(let string):
            return ThemeText.articleSector.attributedString(string, lineSpacing: lineSpacing, lineHeight: lineHeight)
        }
    }
}
