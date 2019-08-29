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

    override func awakeFromNib() {
        super.awakeFromNib()

        let bkgdView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(bkgdView)
        selectedBackgroundView = bkgdView
    }

    func configure(title: String,
                   bkgdTheme: ThemeView, titleTheme: ThemeText,
                   arrowHidden: Bool = false, separatorHidden: Bool = false,
                   topMargin: CGFloat = 23.0, bottomMargin: CGFloat = 24.0) {

        bkgdTheme.apply(contentView)
        titleTheme.apply(title, to: titleLabel)

        arrowImageView.isHidden = arrowHidden
        separator.isHidden = separatorHidden
        self.topMargin.constant = topMargin
        self.bottomMargin.constant = bottomMargin
    }
}
