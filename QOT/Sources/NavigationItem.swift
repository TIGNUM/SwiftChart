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
        static var dark = Style(tabFont: Font.H5SecondaryHeadline, defaultColor: .gray, selectedColor: .white)
        static var light = Style(tabFont: Font.H5SecondaryHeadline, defaultColor: .black40, selectedColor: .black)
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

    func setBadge(index: Int, hidden: Bool) {
        tabMenuView.setBadge(index: index, hidden: hidden)
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

    func showTabMenuView() {
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

private class TabMenuView: UIView {

    private let minFontScale: CGFloat = 0.5
    private let spacing: CGFloat = 15
    private(set) var buttons: [UIButton] = []
    private(set) var badges: [Int: Badge] = [:]
    private(set) var style: NavigationItem.Style = .dark
    private(set) var selectedIndex: Int?
    private(set) var titles: [String] = []
    let indicatorView = UIView()
    var didSelectTabAtIndex: ((TabMenuView, Int) -> Void)?

    override var intrinsicContentSize: CGSize {
        let sizes = buttonSizes(titles: titles, font: style.tabFont)
        return intrinsicContentSize(buttonSizes: sizes, spacing: spacing)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let intrinsic = intrinsicContentSize
        let width = min(targetSize.width, intrinsic.width)
        return CGSize(width: width, height: targetSize.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutButtons()
        layoutBadges()
        layoutIndicatorView(animated: false)
    }

    func setStyle(_ style: NavigationItem.Style) {
        self.style = style
        syncAppearance()
        layoutButtons()
        layoutIndicatorView(animated: false)
    }

    func setTitles(_ titles: [String]) {
        self.titles = titles
        validateSelectedIndex()
        syncButtons(titles: titles)
        syncAppearance()
        layoutButtons()
        layoutBadges()
        layoutIndicatorView(animated: false)
    }

    func setSelectedIndex(_ index: Int, animated: Bool) {
        guard index >= 0, index < buttons.count else { return }
        selectedIndex = index
        syncAppearance()
        layoutIndicatorView(animated: animated)
    }

    func setBadge(index: Int, hidden: Bool) {
        if let badge = badges[index] {
            badge.isHidden = hidden
        } else if hidden == false {
            let newBadge =  Badge()
            newBadge.backgroundColor = .cherryRed
            badges[index] = newBadge
            addSubview(newBadge)
        }
        layoutBadges()
    }

    private func validateSelectedIndex() {
        if let selectedIndex = selectedIndex, selectedIndex >= 0, selectedIndex < titles.count {
            return // selectedIndex is valid so do nothing
        } else {
            selectedIndex = titles.isEmpty ? nil : 0
        }
    }

    func syncAppearance() {
        if indicatorView.superview == nil {
            addSubview(indicatorView)
        }
        indicatorView.backgroundColor = style.selectedColor
        indicatorView.isHidden = titles.count <= 1
        for (index, button) in buttons.enumerated() {
            let titleColor = index == selectedIndex ? style.selectedColor : style.defaultColor
            button.setTitleColor(titleColor, for: .normal)
        }
    }

    private func buttonSizes(titles: [String], font: UIFont) -> [CGSize] {
        return titles.map { return ($0 as NSString).size(withAttributes: [.font: font]).ceiled }
    }

    private func intrinsicContentSize(buttonSizes: [CGSize], spacing: CGFloat) -> CGSize {
        let totalSpacing = max(CGFloat(0), (CGFloat(titles.count - 1) * spacing))
        let width = buttonSizes.reduce(totalSpacing) { $0 + $1.width }
        let height = buttonSizes.reduce(0, { max($0, $1.height) })
        return CGSize(width: width, height: height)
    }

    private func buttonFrames(buttonSizes: [CGSize], spacing: CGFloat, origin: CGPoint, height: CGFloat) -> [CGRect] {
        var origin = origin
        var frames: [CGRect] = []
        for size in buttonSizes {
            frames.append(CGRect(origin: origin, size: CGSize(width: size.width, height: height)))
            origin.x += size.width + spacing
        }
        return frames
    }

    private func syncButtons(titles: [String]) {
        var buttons = self.buttons
        let missingButtonsCount = max(titles.count - buttons.count, 0)
        for _ in 0..<missingButtonsCount {
            let button = UIButton(type: .custom)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        for (index, title) in titles.enumerated() {
            let button = buttons[index]
            button.tag = index
            button.setTitle(title, for: .normal)
        }
        self.buttons = buttons
    }

    private func buttonLayout() -> (font: UIFont, frames: [CGRect]) {
        let descriptor = style.tabFont.fontDescriptor
        let maxFontSize = descriptor.pointSize
        let minFontSize = maxFontSize * minFontScale
        for fontSize in stride(from: maxFontSize, to: minFontSize, by: -1.0 as CGFloat) {
            let font = UIFont(descriptor: descriptor, size: fontSize)
            let sizes = buttonSizes(titles: titles, font: font)
            let contentWidth = intrinsicContentSize(buttonSizes: sizes, spacing: spacing).width
            if contentWidth <= bounds.width {
                let x = floor((bounds.width - contentWidth) / 2)
                let origin = CGPoint(x: x, y: 0)
                let frames = buttonFrames(buttonSizes: sizes, spacing: spacing, origin: origin, height: bounds.height)
                return (font, frames)
            }
        }
        let sizes = buttonSizes(titles: titles, font: style.tabFont)
        let frames = buttonFrames(buttonSizes: sizes, spacing: spacing, origin: .zero, height: bounds.height)
        return (style.tabFont, frames)
    }

    private func layoutButtons() {
        let layout = buttonLayout()
        for (index, button) in buttons.enumerated() {
            button.titleLabel?.font = layout.font
            button.frame = layout.frames[index]
        }
    }

    private func layoutBadges() {
        for (index, badge) in badges {
            guard index < buttons.count, let label = buttons[index].titleLabel else { continue }
            let button = buttons[index]
            button.setNeedsLayout()
            button.layoutIfNeeded()
            let labelFrame = button.convert(label.frame, to: self)
            let size = CGSize(width: 6, height: 6)
            let origin = CGPoint(x: labelFrame.maxX, y: labelFrame.minY - size.height)
            badge.frame = CGRect(origin: origin, size: size)
        }
    }

    private func layoutIndicatorView(animated: Bool) {
        guard let selectedIndex = selectedIndex else { return }
        let buttonFrame = buttons[selectedIndex].frame
        let indicatorFrame = CGRect(x: buttonFrame.minX, y: bounds.height - 1, width: buttonFrame.width, height: 1)
        let duration: TimeInterval = animated == true ? 0.3 : 0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.indicatorView.frame = indicatorFrame
        })
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        didSelectTabAtIndex?(self, sender.tag)
        setSelectedIndex(index, animated: true)
    }
}
