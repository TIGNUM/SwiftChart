//
//  ArticleItemTopTabBarView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 07/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol ArticleItemTopTabBarViewDelegate: class {
    func didTapLeftButton()
}

class ArticleItemTopTabBarView: UIView {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: ArticleItemTopTabBarViewDelegate?

    func setup(title: String, leftButtonIcon: UIImage? = nil, delegate: ArticleItemTopTabBarViewDelegate? = nil) {

        self.delegate = delegate
        titleLabel.addCharactersSpacing(spacing: 1, text: title, uppercased: true)
        titleLabel.font = Font.H5SecondaryHeadline
        titleLabel.textColor = .white

        if leftButtonIcon != nil {
            setButton(leftButton, image: leftButtonIcon, selector: #selector(ArticleItemTopTabBarView.didTapLeftButton), tintColor: .white)
        } else {
            leftButton.isHidden = true
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

    func didTapLeftButton() {
        delegate?.didTapLeftButton()
    }
}
