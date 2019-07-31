//
//  HeaderDetailsItemCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 25/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class HeaderDetailsItemCell: UITableViewCell, BaseMySprintDetailsItemCellInterface, Dequeueable {
    @IBOutlet weak var itemTextLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    lazy var characterSpacing: CGFloat = {
        return 0.2
    }()

    func setButton(tag: Int, target: Any, selector: Selector) {
        editButton.isHidden = false
        editButton.tag = tag
        editButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}
