//
//  TopNavigationBar.swift
//  QOT
//
//  Created by Lee Arromba on 27/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import Anchorage

protocol TopNavigationBarDelegate: class {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem)

    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int)

    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem)
}

final class TopNavigationBar: UINavigationBar {

    private let spacing: CGFloat = 15.0
    private let lineHeight: CGFloat = 1.0
    private var currentButton: UIButton?
    private var indicatorViewWidthConstraint: NSLayoutConstraint!
    private var indicatorViewLeftConstraint: NSLayoutConstraint!
    let indicatorView: UIView // automatically hidden when setMiddleButtons(buttons.count == 1)
    weak var topNavigationBarDelegate: TopNavigationBarDelegate?
    var middleButtons: [UIButton]?
    var currentButtonIndex: Int? {
        guard let currentButton = currentButton, let middleButtons = middleButtons else {
            return nil
        }
        return middleButtons.index(of: currentButton)
    }

    override init(frame: CGRect) {
        indicatorView = UIView()
        indicatorView.backgroundColor = .white

        super.init(frame: frame)

        applyDefaultStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        indicatorView = UIView()
        indicatorView.backgroundColor = .white

        super.init(coder: aDecoder)

        applyDefaultStyle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let currentButton = currentButton else { return }
        setIndicatorToButton(currentButton, animated: false)
        setIsSelected(currentButton)
    }

    func setStyle(selectedColor: UIColor, normalColor: UIColor, backgroundColor: UIColor) {
        middleButtons?.forEach { (button: UIButton) in
            button.setTitleColor(normalColor, for: .normal)
            button.setTitleColor(selectedColor, for: .selected)
        }

        topItem?.leftBarButtonItem?.tintColor = normalColor
        topItem?.rightBarButtonItem?.tintColor = normalColor
        indicatorView.backgroundColor = selectedColor
        self.backgroundColor = backgroundColor
    }

    func setMiddleButtons(_ buttons: [UIButton]) {
        guard let topItem = topItem, buttons.count > 0 else { return }
        var width: CGFloat = 0.0
        let firstButton = buttons[0]
        middleButtons = buttons

        // @note need to layout buttons with sizeToFit to obtain early width calculation
        for (index, button) in buttons.enumerated() {
            button.addTarget(self, action: #selector(middleButtonPressed(_:)), for: .touchUpInside)
            button.sizeToFit()
            button.tag = index
            width += button.bounds.size.width
        }

        let view = UIStackView(arrangedSubviews: buttons)
        view.frame = CGRect(x: 0, y: 0, width: (width + CGFloat(buttons.count) * spacing), height: bounds.size.height)
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = spacing
        view.addSubview(indicatorView)
        topItem.titleView = view

        indicatorView.bottomAnchor == view.bottomAnchor - lineHeight
        indicatorView.heightAnchor == lineHeight
        indicatorViewWidthConstraint = indicatorView.widthAnchor == firstButton.bounds.width
        indicatorViewLeftConstraint = indicatorView.leftAnchor == firstButton.leftAnchor
        indicatorView.isHidden = (buttons.count == 1)
        currentButton = buttons[0]
    }

    func setLeftButton(_ button: UIBarButtonItem?) {
        guard let topItem = topItem else { return }

        button?.target = self
        button?.action = #selector(leftButtonPressed(_:))
        topItem.leftBarButtonItem = button
    }

    func setRightButton(_ button: UIBarButtonItem?) {
        guard let topItem = topItem else { return }

        button?.target = self
        button?.action = #selector(rightButtonPressed(_:))
        topItem.rightBarButtonItem = button
    }

    func setIndicatorToButtonIndex(_ index: Int, animated: Bool = true) {
        guard let middleButtons = middleButtons, index >= 0, index < middleButtons.count else { return }

        setIndicatorToButton(middleButtons[index], animated: animated)
    }

    func setIndicatorToButton(_ button: UIButton, animated: Bool = true) {
        guard let titleView = topItem?.titleView, titleView.subviews.contains(button) else { return }
        setIsSelected(button)
        indicatorViewWidthConstraint.constant = button.bounds.width
        indicatorViewLeftConstraint.constant = button.frame.origin.x
        if animated == true {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }

    func setIsSelected(_ button: UIButton) {
        middleButtons?.forEach({ $0.isSelected = ($0 == button) })
    }

    // MARK: - private

    @objc private func leftButtonPressed(_ sender: UIBarButtonItem) {
        topNavigationBarDelegate?.topNavigationBar(self, leftButtonPressed: sender)
    }

    @objc private func rightButtonPressed(_ sender: UIBarButtonItem) {
        topNavigationBarDelegate?.topNavigationBar(self, rightButtonPressed: sender)
    }

    @objc private func middleButtonPressed(_ sender: UIButton) {
        guard let total = middleButtons?.count else { return }
        topNavigationBarDelegate?.topNavigationBar(self, middleButtonPressed: sender, withIndex: sender.tag, ofTotal: total)
        setIndicatorToButton(sender)
        currentButton = sender
    }
}
