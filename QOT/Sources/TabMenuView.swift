//
//  TabMenuView.swift
//  QOT
//
//  Created by karmic on 21.09.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class TabMenuView: UIView {

    private let minFontScale: CGFloat = 0.5
    private let spacing: CGFloat = 15
    private(set) var buttons: [UIButton] = []
    private(set) var badges: [Int: Badge] = [:]
    private(set) var style: NavigationItem.Style = .dark
    private(set) var selectedIndex: Int?
    private(set) var titles: [String] = []
    let indicatorView = UIView()
    var didSelectTabAtIndex: ((TabMenuView, Int) -> Void)?
    private var buttonFrame: CGRect {
        return buttons[selectedIndex ?? 0].frame
    }
    private var indicatorFrame: CGRect {
        let isLearn = titles.contains(obj: R.string.localized.topTabBarItemTitleLearnWhatsHot().uppercased())
        let padding = isLearn ? Layout.padding_10 : -Layout.padding_1
        return CGRect(x: buttonFrame.minX, y: bounds.height + padding, width: buttonFrame.width, height: 1)
    }

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
        layoutIndicatorView(animated: false)
    }

    func setSelectedIndex(_ index: Int, animated: Bool) {
        guard index >= 0, index < buttons.count else { return }
        selectedIndex = index
        syncAppearance()
        layoutIndicatorView(animated: animated)
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

    private func layoutIndicatorView(animated: Bool) {
        guard let selectedIndex = selectedIndex else { return }
        let duration: TimeInterval = animated == true ? 0.3 : 0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.indicatorView.frame = self.indicatorFrame
        })
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        didSelectTabAtIndex?(self, sender.tag)
        setSelectedIndex(index, animated: true)
    }
}
