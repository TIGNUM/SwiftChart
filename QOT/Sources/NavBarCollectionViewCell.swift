//
//  NavBarCollectionReusableView.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 22/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class NavBarCollectionViewCell: UICollectionViewCell, Dequeueable {

    typealias actionClosure = (() -> Void)

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    private var actionLeft: actionClosure? = nil
    private var actionRight: actionClosure? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level1.apply(self)

        buttonLeft.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        buttonRight.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
    }

    func configure(title: String, tapLeft: actionClosure? = nil, tapRight: actionClosure? = nil) {
        container.alpha = 1.0
        ThemeText.navigationBarHeader.apply(title, to: titleLabel)
        buttonLeft.isHidden = tapLeft == nil
        buttonRight.isHidden = tapRight == nil

        actionLeft = tapLeft
        actionRight = tapRight
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
