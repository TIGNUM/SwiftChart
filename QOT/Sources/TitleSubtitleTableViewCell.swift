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

    var title: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }
    var subTitle: String = ""{
        willSet {
            subTitleLabel.text = newValue
        }
    }

    struct Config {
        var backgroundColor: UIColor
        var subTitlefont: UIFont
        var titlefont: UIFont
        var titleTextColor: UIColor
        var subTitleTextColor: UIColor

        init(backgroundColor: UIColor = UIColor.carbon,
             subTitlefont: UIFont = UIFont.sfProtextMedium(ofSize: FontSize.fontSize12),
             titlefont: UIFont = UIFont.sfProtextLight(ofSize: FontSize.fontSize16),
             titleTextColor: UIColor = UIColor.sand,
             subTitleTextColor: UIColor = UIColor.sand30) {
            self.backgroundColor = backgroundColor
            self.subTitlefont = subTitlefont
            self.titlefont = titlefont
            self.titleTextColor = titleTextColor
            self.subTitleTextColor = subTitleTextColor
        }
    }

    var config: Config? {
        didSet {
            subTitleLabel.textColor = config?.subTitleTextColor
            subTitleLabel.font = config?.subTitlefont
            titleLabel.textColor = config?.titleTextColor
            titleLabel.font = config?.titlefont
            contentView.backgroundColor = config?.backgroundColor
        }
    }
}
