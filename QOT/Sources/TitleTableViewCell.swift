//
//  TitleTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var separator: UIView!

    struct Config {
        var backgroundColor: UIColor
        var titlefont: UIFont
        var titleTextColor: UIColor
        var isArrowHidden: Bool
        var isSeparatorHidden: Bool
        var topMargin: CGFloat
        var bottomMargin: CGFloat

        init(backgroundColor: UIColor = UIColor.carbonDark,
             titlefont: UIFont = UIFont.sfProtextLight(ofSize: FontSize.fontSize16),
             titleTextColor: UIColor = UIColor.sand,
             isArrowHidden: Bool = false,
             isSeparatorHidden: Bool = false,
             bottomMargin: CGFloat = 23,
             topMargin: CGFloat = 24) {
            self.backgroundColor = backgroundColor
            self.titlefont = titlefont
            self.titleTextColor = titleTextColor
            self.isArrowHidden = isArrowHidden
            self.isSeparatorHidden = isSeparatorHidden
            self.topMargin = topMargin
            self.bottomMargin = bottomMargin
        }
    }

    var title: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }

    var config: Config? {
        didSet {
            titleLabel.textColor = config?.titleTextColor
            titleLabel.font = config?.titlefont
            contentView.backgroundColor = config?.backgroundColor
            arrowImageView.isHidden = config?.isArrowHidden ?? false
            topMargin.constant = config?.topMargin ?? 24
            bottomMargin.constant = config?.bottomMargin ?? 23
            separator.isHidden = config?.isSeparatorHidden ?? false
            layoutIfNeeded()
        }
    }
}
