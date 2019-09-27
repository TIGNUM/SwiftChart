//
//  CtaItemDetailsItemCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 25/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class CtaItemDetailsItemCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var itemTextLabel: UILabel!
    @IBOutlet weak var ctaButton: AnimatedButton!

    func setButton(tag: Int, title: String, target: Any, selector: Selector) {
        ctaButton.tag = tag
        ctaButton.addTarget(target, action: selector, for: .touchUpInside)
        ctaButton.setAttributedTitle(ThemeText.mySprintDetailsCta.attributedString(title), for: .normal)
        ctaButton.setAttributedTitle(ThemeText.mySprintDetailsCtaHighlight.attributedString(title), for: .highlighted)
    }
}
