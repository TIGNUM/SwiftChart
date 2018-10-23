//
//  NavigationItem.swift
//  QOT
//
//  Created by Lee Arromba on 27/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import Anchorage

protocol NavigationItemDelegate: class {
    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem)
    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int)
    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem)
}

final class NavigationItem: UINavigationItem {

    struct Style {
        let tabFont: UIFont
        let defaultColor: UIColor
        let selectedColor: UIColor
        static var dark = Style(tabFont: .H5SecondaryHeadline, defaultColor: .white, selectedColor: .white)
        static var light = Style(tabFont: .H5SecondaryHeadline, defaultColor: .black40, selectedColor: .black)
    }

    private lazy var tabMenuView: TabMenuView = {
        let view = TabMenuView()
        view.didSelectTabAtIndex = { [weak self] (view, index) in
                guard let `self` = self else { return }
                let buttonCount = view.titles.count
                self.delegate?.navigationItem(self, middleButtonPressedAtIndex: index, ofTotal: buttonCount)
        }
        self.titleView = view
        return view
    }()

    weak var delegate: NavigationItemDelegate?
    private var tabTitles = [String]()

    func configure(leftButton: UIBarButtonItem?,
                   rightButton: UIBarButtonItem?,
                   tabTitles: [String],
                   style: Style) {
        self.tabTitles = tabTitles
        tabMenuView.setTitles(tabTitles)
        tabMenuView.setStyle(style)
        let tabMenuSize = CGSize(width: tabMenuView.intrinsicContentSize.width, height: 44)
        tabMenuView.frame = CGRect(origin: .zero, size: tabMenuSize) // We need set the size for iOS 10
        leftButton?.tintColor = style.defaultColor
        leftButton?.target = self
        leftButton?.action = #selector(didTapLeftButton(_:))
        leftBarButtonItem = leftButton
        rightButton?.tintColor = style.defaultColor
        rightButton?.target = self
        rightButton?.action = #selector(didTapRightButton(_:))
        rightBarButtonItem = rightButton
    }

    func middleButton(index: Int) -> UIButton? {
        guard index > 0 && index < tabMenuView.buttons.count else { return nil }
        return tabMenuView.buttons[index]
    }

    func setIndicatorToButtonIndex(_ index: Int, animated: Bool = true) {
        tabMenuView.setSelectedIndex(index, animated: animated)
    }

    func hideTabMenuView() {
        UIView.animate(withDuration: Animation.duration) { [weak self] in
            self?.tabMenuView.alpha = 0
            self?.tabMenuView.buttons.forEach { $0.setTitleColor(.clear, for: .normal) }
            self?.tabMenuView.indicatorView.alpha = 0
            self?.leftBarButtonItem?.tintColor = .clear
            self?.rightBarButtonItem?.tintColor = .clear
        }
    }

    func showTabMenuView(titles: [String]) {
        tabMenuView.setTitles(titles)
        UIView.animate(withDuration: Animation.duration) { [weak self] in
            self?.tabMenuView.alpha = 1
            self?.tabMenuView.syncAppearance()
            self?.tabMenuView.indicatorView.alpha = 1
            self?.leftBarButtonItem?.tintColor = self?.tabMenuView.style.defaultColor
            self?.rightBarButtonItem?.tintColor = self?.tabMenuView.style.defaultColor
        }
    }
}

// MARK: - Actions

extension NavigationItem {

    @objc private func didTapLeftButton(_ sender: UIBarButtonItem) {
        delegate?.navigationItem(self, leftButtonPressed: sender)
    }

    @objc private func didTapRightButton(_ sender: UIBarButtonItem) {
        delegate?.navigationItem(self, rightButtonPressed: sender)
    }
}
