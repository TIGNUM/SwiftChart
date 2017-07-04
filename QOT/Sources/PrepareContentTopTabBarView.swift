//
//  PrepareContentTopTabBarView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 03/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentTopTabBarViewDelegate: class {
    func didTapLeftButton()
    func didTapRightButton()
}

class PrepareContentTopTabBarView: UIView {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: PrepareContentTopTabBarViewDelegate?

    func setup(title: String, leftButtonIcon: UIImage? = nil, rightButtonIcon: UIImage? = nil, delegate: PrepareContentTopTabBarViewDelegate? = nil) {

        self.delegate = delegate
        titleLabel.prepareAndSetTextAttributes(text: title.uppercased(), font: Font.H6NavigationTitle)

        if leftButtonIcon != nil {
            setButton(leftButton, image: leftButtonIcon, selector: #selector(PrepareContentTopTabBarView.didTapLeftButton))
        } else {
            leftButton.isHidden = true
        }

        if rightButtonIcon != nil {
            setButton(rightButton, image: rightButtonIcon, selector: #selector(PrepareContentTopTabBarView.didTapRightButton))
        } else {
            rightButton.isHidden = true
        }
    }

    private func setButton(_ button: UIButton, image: UIImage?, selector: Selector) {
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .black
        button.tintColor = .black
        button.isHidden = image == nil
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setTitle("", for: .normal)

        button.addTarget(self, action: selector, for: .touchUpInside)
    }

    func didTapLeftButton() {
        delegate?.didTapLeftButton()
    }

    func didTapRightButton() {
        delegate?.didTapRightButton()
    }
}
