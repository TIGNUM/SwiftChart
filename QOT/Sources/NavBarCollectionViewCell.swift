//
//  NavBarCollectionReusableView.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 22/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class NavBarCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .carbon
    }

    func configure(title: String, leftArrow: Bool, rightArrow: Bool) {
        container.alpha = 1.0
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       letterSpacing: 0.4,
                                                       font: .sfProtextRegular(ofSize: 20),
                                                       lineSpacing: 5,
                                                       textColor: .sand,
                                                       alignment: .left)
        buttonLeft.isHidden = !leftArrow
        buttonRight.isHidden = !rightArrow
    }

    func updateAlpha(basedOn offsetY: CGFloat) {
        let offset = container.frame.maxY - offsetY
        if offset < 0 {
            container.alpha = 0.0
        } else {
            container.alpha = (offset / container.frame.maxY)
        }
    }
}
