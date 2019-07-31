//
//  ListItemDetailsItemCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 25/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class ListItemDetailsItemCell: UITableViewCell, BaseMySprintDetailsItemCellInterface, Dequeueable {
    @IBOutlet weak var itemTextLabel: UILabel!

    lazy var characterSpacing: CGFloat = {
        return 0.5
    }()

    func setAppearance(_ appearance: MySprintDetailsItem.Appearance) {
        let color: UIColor
        switch appearance {
        case .info:
            color = .sand40
        case .regular:
            color = .sand70
        case .active:
            color = .sand
            itemTextLabel.font = UIFont.sfProtextMedium(ofSize: 16)
        }
        itemTextLabel.textColor = color
    }
}
