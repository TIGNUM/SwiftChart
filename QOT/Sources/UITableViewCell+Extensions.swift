//
//  UITableViewCell+Extensions.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 05.11.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension UITableViewCell {

    func bodyAttributedText(text: String,
                            font: UIFont,
                            lineSpacing: CGFloat = 10,
                            breakMode: NSLineBreakMode? = .byWordWrapping) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         font: font,
                                         lineSpacing: lineSpacing,
                                         textColor: .white,
                                         alignment: .left,
                                         lineBreakMode: breakMode)
    }

    func setSelectedColor(_ color: UIColor, alphaComponent: CGFloat? = 1) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = color.withAlphaComponent(0.1)
        selectedBackgroundView = backgroundView
    }
}

extension UICollectionViewCell {

    func bodyAttributedText(text: String,
                            font: UIFont,
                            lineSpacing: CGFloat = 10,
                            breakMode: NSLineBreakMode? = .byWordWrapping) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         font: font,
                                         lineSpacing: lineSpacing,
                                         textColor: .white,
                                         alignment: .left,
                                         lineBreakMode: breakMode)
    }
}
