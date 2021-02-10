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
        let bkView = UIView()
        bkView.backgroundColor = .tignumPink10
        selectedBackgroundView = bkView
    }

    func configure(title: String, themeCell: ThemeView = .level2) {
        ThemeText.linkMenuItem.apply(title.uppercased(), to: titleLabel)
    }

    func configure(subTitle: String, isHidden: Bool = false) {
        ThemeText.linkMenuComment.apply(subTitle, to: subTitleLabel)
        subTitleLabel.isHidden = isHidden
    }

    func configure(title: String, subtitle: String) {
        ThemeText.syncedCalendarRowTitle.apply(title, to: titleLabel)
        ThemeText.syncedCalendarRowSubtitle.apply(subtitle, to: subTitleLabel)
    }

    var hideArrow: Bool = false {
        willSet {
            arrowRight.isHidden = newValue
        }
    }
}
