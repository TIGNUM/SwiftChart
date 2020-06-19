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
    let skeletonManager = SkeletonManager()

    private var actionLeft: actionClosure?
    private var actionRight: actionClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level1.apply(self)

        buttonLeft.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        buttonRight.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        buttonLeft.isHidden = true
        buttonRight.isHidden = true
    }

    func configure(title: String, tapLeft: actionClosure? = nil, tapRight: actionClosure? = nil) {
        container.alpha = 1.0
        ThemeText.navigationBarHeader.apply(title, to: titleLabel)
        buttonLeft.isHidden = tapLeft == nil
        buttonRight.isHidden = tapRight == nil

        actionLeft = tapLeft
        actionRight = tapRight
    }

    func setSettingsButton(_ title: String) {
        buttonRight.setImage(nil, for: .normal)
        buttonRight.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        buttonRight.setAttributedTitle(NSAttributedString(string: "M",
                                                          attributes: [.foregroundColor: UIColor.carbon,
                                                                       .font: UIFont.sfProtextSemibold(ofSize: 17)]),
                                       for: .normal)
        buttonRight.circle()
        buttonRight.backgroundColor = .accent
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
