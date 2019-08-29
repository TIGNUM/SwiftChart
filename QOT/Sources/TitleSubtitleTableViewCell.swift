//
//  TitleSubtitleTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class TitleSubtitleTableViewCell: UITableViewCell, Dequeueable {

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
        ThemeText.linkMenuItem.apply(title.uppercased(), to: titleLabel)
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
