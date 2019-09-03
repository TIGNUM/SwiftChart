//
//  NavBarTableViewCell.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 22/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class NavBarTableViewCell : UIView {

    typealias actionClosure = (() -> Void)

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    private var actionLeft: actionClosure? = nil
    private var actionRight: actionClosure? = nil

    static func instantiateFromNib(title: String, tapLeft: actionClosure? = nil, tapRight: actionClosure? = nil) -> NavBarTableViewCell {
        guard let navBar = R.nib.navBarTableViewCell.instantiate(withOwner: self).first as? NavBarTableViewCell else {
            fatalError("Cannot load nav bar")
        }
        navBar.backgroundColor = .carbon
        navBar.configure(title: title, tapLeft: tapLeft, tapRight: tapRight)
        return navBar
    }


    func configure(title: String, tapLeft: actionClosure?, tapRight: actionClosure?) {
        ThemeView.level1.apply(self)
        container.alpha = 1.0
        ThemeText.navigationBarHeader.apply(title, to: titleLabel)
        buttonLeft.isHidden = tapLeft == nil
        buttonRight.isHidden = tapRight == nil
        actionLeft = tapLeft
        actionRight = tapRight
        buttonLeft.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        buttonRight.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
    }

    func updateAlpha(basedOn offsetY: CGFloat) {
        let offset = container.frame.maxY - offsetY
        if offset < 0 {
            container.alpha = 0.0
        } else {
            container.alpha = (offset / container.frame.maxY)
        }
    }

    @objc func didTapLeft() {
        actionLeft?()
    }

    @objc func didTapRight() {
        actionRight?()
    }
}
