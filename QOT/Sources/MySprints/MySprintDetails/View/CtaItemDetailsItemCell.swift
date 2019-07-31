//
//  CtaItemDetailsItemCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 25/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class CtaItemDetailsItemCell: UITableViewCell, BaseMySprintDetailsItemCellInterface, Dequeueable {
    @IBOutlet weak var itemTextLabel: UILabel!
    @IBOutlet weak var ctaButton: UIButton!

    var characterSpacing: CGFloat = {
        return 0.2
    }()

    func setButton(tag: Int, title: String, target: Any, selector: Selector) {
        ctaButton.tag = tag
        ctaButton.addTarget(target, action: selector, for: .touchUpInside)
        ctaButton.setAttributedTitle(NSAttributedString(string: title,
                                                        attributes: [.kern: CharacterSpacing.kern02]), for: .normal)
    }
}
