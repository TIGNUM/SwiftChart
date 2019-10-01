//
//  ListItemDetailsItemCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 25/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class ListItemDetailsItemCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var itemTextLabel: UILabel!

    func setText(text: String, appearance: MySprintDetailsItem.Appearance) {
        switch appearance {
        case .info: ThemeText.mySprintDetailsTextInfo.apply(text, to: itemTextLabel)
        case .regular: ThemeText.mySprintDetailsTextRegular.apply(text, to: itemTextLabel)
        case .active: ThemeText.mySprintDetailsTextActive.apply(text, to: itemTextLabel)
        }
    }
}
