//
//  HeaderDetailsItemCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 25/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class HeaderDetailsItemCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var itemTextLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    func setText(_ text: String) {
        ThemeText.mySprintDetailsHeader.apply(text, to: itemTextLabel)
    }

    func setButton(tag: Int, target: Any, selector: Selector) {
        editButton.isHidden = false
        editButton.tag = tag
        editButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}
