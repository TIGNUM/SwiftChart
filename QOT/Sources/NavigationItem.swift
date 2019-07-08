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
    func navigationItem(_ navigationItem: NavigationItem, searchButtonPressed button: UIBarButtonItem)
}

final class NavigationItem: UINavigationItem {

    struct Style {
        let tabFont: UIFont
        let defaultColor: UIColor
        let selectedColor: UIColor
        static var dark = Style(tabFont: .H5SecondaryHeadline, defaultColor: .white, selectedColor: .white)
        static var light = Style(tabFont: .H5SecondaryHeadline, defaultColor: .black40, selectedColor: .black)
        static var sand = Style(tabFont: UIFont.apercuRegular(ofSize: 20), defaultColor: .sand, selectedColor: .sand)
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

    func configure(leftButtons: [UIBarButtonItem],
                   rightButtons: [UIBarButtonItem],
                   tabTitles: [String],
                   style: Style) {
        setupView(tabTitles: tabTitles, style: style)
        addLeftButtons(leftButtons: leftButtons, style: style)
        addRightButtons(rightButtons: rightButtons, style: style)
    }

    func configure(leftButton: UIBarButtonItem?,
                   rightButton: UIBarButtonItem?,
                   tabTitles: [String],
                   style: Style,
                   hasSearchButton: Bool = false) {
        setupView(tabTitles: tabTitles, style: style)
        if let leftButton = leftButton {
            addLeftButtons(leftButtons: [leftButton], style: style)
        }
        if let rightButton = rightButton {
            addRightButtons(rightButtons: [rightButton], style: style)
            if hasSearchButton == true {
                addSearchButton(style: style)
            }
        }
    }

    func middleButton(index: Int) -> UIButton? {
        guard index > 0 && index < tabMenuView.buttons.count else { return nil }
        return tabMenuView.buttons[index]
    }

    func setIndicatorToButtonIndex(_ index: Int, animated: Bool = true) {
        tabMenuView.setSelectedIndex(index, animated: animated)
    }

    func hideTabMenuView() {
        UIView.animate(withDuration: Animation.duration_03) { [weak self] in
            self?.tabMenuView.alpha = 0
            self?.tabMenuView.buttons.forEach { $0.setTitleColor(.clear, for: .normal) }
            self?.tabMenuView.indicatorView.alpha = 0
            self?.leftBarButtonItem?.tintColor = .clear
            self?.rightBarButtonItem?.tintColor = .clear
        }
    }

    func showTabMenuView(titles: [String]) {
        tabMenuView.setTitles(titles)
        UIView.animate(withDuration: Animation.duration_03) { [weak self] in
            self?.tabMenuView.alpha = 1
            self?.tabMenuView.syncAppearance()
            self?.tabMenuView.indicatorView.alpha = 1
            self?.leftBarButtonItem?.tintColor = self?.tabMenuView.style.defaultColor
            self?.rightBarButtonItem?.tintColor = self?.tabMenuView.style.defaultColor
        }
    }
}

// MARK: - Private

private extension NavigationItem {
    func setupView(tabTitles: [String], style: Style) {
        self.tabTitles = tabTitles
        tabMenuView.setTitles(tabTitles)
        tabMenuView.setStyle(style)
        let tabMenuSize = CGSize(width: tabMenuView.intrinsicContentSize.width, height: 44)
        tabMenuView.frame = CGRect(origin: .zero, size: tabMenuSize) // We need set the size for iOS 10
    }

    func addSearchButton(style: Style) {
        let searchButton = UIBarButtonItem(image: R.image.ic_search(),
                                           style: .plain,
                                           target: self,
                                           action: #selector(didTapSearch(_:)))
        searchButton.tintColor = style.defaultColor
        searchButton.imageInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
        addRightButtons(rightButtons: [searchButton], style: style)
    }

    func addLeftButtons(leftButtons: [UIBarButtonItem], style: Style) {
        var leftItems = [UIBarButtonItem]()
        leftButtons.forEach { leftButton in
            leftButton.tintColor = style.defaultColor
            leftButton.target = self
            leftButton.action = #selector(didTapLeftButton(_:))
            leftItems.append(leftButton)
        }
        leftBarButtonItems = leftItems
    }

    func addRightButtons(rightButtons: [UIBarButtonItem], style: Style) {
        var rightItems = [UIBarButtonItem]()
        rightButtons.forEach { rightButton in
            rightButton.tintColor = style.defaultColor
            rightButton.target = self
            rightButton.action = #selector(didTapRightButton(_:))
            rightItems.append(rightButton)
        }
        rightBarButtonItems = rightItems
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

    @objc private func didTapSearch(_ sender: UIBarButtonItem) {
        delegate?.navigationItem(self, searchButtonPressed: sender)
    }
}
