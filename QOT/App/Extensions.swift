//
//  Extensions.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIFont

extension UIFont {
    
    // MARK: - Private
    
    private class func simpleFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.simple.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    private class func bentonBookFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonBook.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    private class func bentonRegularFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonBook.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    // MARK: - Public
    
    class var qotSidebarSmall: UIFont {
        return UIFont.simpleFont(ofSize: 16)
    }
    
    class var qotSidebar: UIFont {
        return UIFont.simpleFont(ofSize: 32)
    }

    class var qotLearnHeadertitle: UIFont {
        return UIFont.simpleFont(ofSize: 36)
    }

    class var qotLearnHeaderSubtitle: UIFont {
        return UIFont.bentonRegularFont(ofSize: 11)
    }

    class var qotLearnText: UIFont {
        return UIFont.bentonBookFont(ofSize: 16)
    }

    class var qotLearnArticleHeaderTitle: UIFont {
        return UIFont.simpleFont(ofSize: 24)
    }

    class var qotLearnArticleTitle: UIFont {
        return UIFont.simpleFont(ofSize: 20)
    }
}

// MARK: - UIColor

extension UIColor {
    
    class var qotWhite: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    class var qotWhiteLight: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    }
    
    class var qotWhiteMedium: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
    }
    
    class var qotNavy: UIColor {
        return UIColor(red: 0, green: 45/255, blue: 78/255, alpha: 1)
    }

    class var qotLearnHeaderTitle: UIColor {
        return UIColor(red: 4/255, green: 8/255, blue: 20/255, alpha: 1)
    }

    class var qotLearnHeaderSubtitle: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
    }

    class var qotLearnVideoDescription: UIColor {
        return UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.6)
    }

    class var qotLearnArticleSubtitle: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    }

    class var qotBlack: UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }

}

// MARK: - NSAttributedString

extension NSAttributedString {

    private class func create(for string: String, withColor color: UIColor, andFont font: UIFont) -> NSAttributedString {
        let attributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
        return NSAttributedString(string: string, attributes: attributes)
    }

    class func qotLearnHeaderTitle(string: String) -> NSAttributedString {
        return NSAttributedString.create(for: string, withColor: .qotLearnHeaderTitle, andFont: .qotLearnHeadertitle)
    }

    class func qotLearnHeaderSubtitle(string: String) -> NSAttributedString {
        return NSAttributedString.create(for: string, withColor: .qotLearnHeaderSubtitle, andFont: .qotLearnHeaderSubtitle)
    }

    class func qotLearnText(string: String) -> NSAttributedString {
        return NSAttributedString.create(for: string, withColor: .qotBlack, andFont: .qotLearnText)
    }

    class func qotLearnVideoDescription(string: String) -> NSAttributedString {
        return NSAttributedString.create(for: string, withColor: .qotLearnVideoDescription, andFont: .qotLearnText)
    }

    class func qotLearnReadMoreHeaderTitle(string: String) -> NSAttributedString {
        return NSAttributedString.create(for: string, withColor: .qotBlack, andFont: .qotLearnArticleHeaderTitle)
    }

    class func qotLearnReadMoreHeaderSubtitle(string: String) -> NSAttributedString {
        return NSAttributedString.create(for: string, withColor: .qotLearnArticleSubtitle, andFont: .qotLearnHeaderSubtitle)
    }

    class func qotLearnArticleTitle(string: String) -> NSAttributedString {
        return NSAttributedString.create(for: string, withColor: .qotBlack, andFont: .qotLearnArticleTitle)
    }

    class func qotLearnArticleSubtitle(string: String) -> NSAttributedString {
        return NSAttributedString.create(for: string, withColor: .qotLearnArticleSubtitle, andFont: .qotLearnHeaderSubtitle)
    }
}
