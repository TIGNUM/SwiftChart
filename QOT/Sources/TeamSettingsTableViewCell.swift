//
//  TeamSettingsTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 30.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class TeamSettingsTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var arrowRight: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
    }

    func configure(title: String, themeCell: ThemeView = .level2) {
        themeCell.apply(backgroundView!)
        ThemeText.linkMenuItem.apply(title, to: titleLabel)
    }

    func configure(subTitle: String, isHidden: Bool = false) {
        ThemeText.linkMenuComment.apply(subTitle, to: subTitleLabel)
        subTitleLabel.isHidden = isHidden
    }

    var hideArrow: Bool = false {
        willSet {
            arrowRight.isHidden = newValue
        }
    }
}
