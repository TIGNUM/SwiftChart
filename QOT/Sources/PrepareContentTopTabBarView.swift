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

final class PrepareContentTopTabBarView: UIView {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomSeparator: UIView!
    weak var delegate: PrepareContentTopTabBarViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    func setup(title: String,
               leftButtonIcon: UIImage? = nil,
               rightButtonIcon: UIImage? = nil,
               delegate: PrepareContentTopTabBarViewDelegate? = nil) {
        bottomSeparator.backgroundColor = .nightModeBlack30
        self.delegate = delegate
        titleLabel.addCharactersSpacing(spacing: 1, text: title, uppercased: true)
        titleLabel.font = Font.H5SecondaryHeadline
        titleLabel.textColor = .nightModeMainFont
        if leftButtonIcon != nil {
            setButton(leftButton,
                      image: leftButtonIcon,
                      selector: #selector(PrepareContentTopTabBarView.didTapLeftButton),
                      tintColor: .nightModeBlack)
        } else {
            leftButton.isHidden = true
        }

        if rightButtonIcon != nil {
            setButton(rightButton,
                      image: rightButtonIcon,
                      selector: #selector(PrepareContentTopTabBarView.didTapRightButton),
                      tintColor: .nightModeBlack30)
        } else {
            rightButton.isHidden = true
        }
    }

    private func setButton(_ button: UIButton, image: UIImage?, selector: Selector, tintColor: UIColor) {
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = tintColor
        button.isHidden = image == nil
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setTitle("", for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
    }

    @objc func didTapLeftButton() {
        delegate?.didTapLeftButton()
    }

    @objc func didTapRightButton() {
        delegate?.didTapRightButton()
    }
}
