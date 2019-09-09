//
//  ButtonThemeable.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 07/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

struct ButtonTheme {
    let foregroundColor: UIColor
    let backgroundColor: UIColor?
    let borderColor: UIColor?

    init(foreground: UIColor, background: UIColor? = nil, border: UIColor? = nil) {
        foregroundColor = foreground
        backgroundColor = background
        borderColor = border
    }
}

protocol ButtonThemeable {
    var titleAttributes: [NSAttributedStringKey: Any]? { get set }
    var normal: ButtonTheme? { get set }
    var highlight: ButtonTheme? { get set }
    var select: ButtonTheme? { get set }
    var disabled: ButtonTheme? { get set }

    func setTitle(_ title: String?)
    func setAttributedTitle(_ title: NSAttributedString?)
}

extension ButtonThemeable {
    func setAttributedTitle(_ title: NSAttributedString?) {
        // nop - making the method optional
    }
}
