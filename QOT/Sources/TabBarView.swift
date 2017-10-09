//
//  TabBarView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/3/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol TabBarViewDelegate: class {
    func didSelectItemAtIndex(index: Int, sender: TabBarView)
}

class TabBarView: UIView {

    enum Distribution {
        case fillEqually
        case fillProportionally(spacing: CGFloat)
    }

    enum TabBarType {
        case bottom
        case top

        var font: UIFont {
            switch self {
            case .bottom: return Font.H5SecondaryHeadline
            case .top: return Font.H5SecondaryHeadline
            }
        }

        func distribution(width: CGFloat) -> Distribution {
            switch self {
            case .bottom: return .fillEqually
            case .top: return .fillProportionally(spacing: width / 12.0)
            }
        }
    }

    // MARK: Private properties

    fileprivate lazy var indicatorView: UIView = UIView()
    fileprivate var stackViewWidthConstraint: NSLayoutConstraint?
    fileprivate var titles = [String]()
    fileprivate let tabBarType: TabBarType
    private(set) var selectedIndex: Int?
    private(set) var buttons = [UIButton]()
    private(set) var buttonHighlights = [UIImageView]()
    weak var delegate: TabBarViewDelegate?

    var selectedColor: UIColor = .black {
        didSet {
            syncButtonColors(animated: false)
            syncIndicatorViewColor()
        }
    }

    var deselectedColor: UIColor = UIColor.black.withAlphaComponent(0.4) {
        didSet {
            syncButtonColors(animated: false)
        }
    }

    var indicatorViewExtendedWidth: CGFloat = 0 {
        didSet {
            layoutIndicatorView(animated: false)
        }
    }

    // MARK: - Init

    init(tabBarType: TabBarType) {
        self.tabBarType = tabBarType

        super.init(frame: .zero)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overides

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutButtons()
        layoutIndicatorView(animated: false)
    }

    private func setup() {
        setupHierachy()
        layoutIndicatorView(animated: false)
        syncButtonColors(animated: false)
        syncIndicatorViewColor()
    }

    // MARK: Public methods

    @discardableResult func setSelectedIndex(_ index: Int?, animated: Bool) -> Bool {
        guard index != selectedIndex else {
            return false
        }

        selectedIndex = index
        layoutIndicatorView(animated: animated)
        syncButtonColors(animated: animated)
        syncButtonImages(animated: animated)
        syncIndicatorViewColor()
        return true
    }

    func setTitles(_ titles: [String], selectedIndex: Int?) {
        self.titles = titles

        setNeedsLayout()
        syncButtonTitles()
        _ = setSelectedIndex(selectedIndex, animated: false)
    }
    
    func setGlowEffectForButtonIndex(_ index: Int, enabled: Bool) {
        let button = buttons[index]
        if enabled {
            button.layer.addGlowEffect(color: .white)
        } else {
            button.layer.removeGlowEffect()
        }
    }

    // MARK: Private methods

    private func syncButtonTitles() {
        // buttons
        buttons.forEach { $0.removeFromSuperview() }
        buttons = titles.enumerated().map { (index: Index, title: String) in
            let button = UIButton(type: .custom)
            button.setTitle(title.uppercased(), for: .normal)
            button.titleLabel?.font = tabBarType.font
            button.backgroundColor = .clear
            button.setTitleColor(deselectedColor, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            button.tag = index
            
            return button
        }
        buttons.forEach { addSubview($0) }
        
        // highlights
        buttonHighlights.forEach { $0.removeFromSuperview() }
        buttonHighlights = buttons.enumerated().map({ (index: Index, button: UIButton) in
            let imageView = UIImageView(image: R.image.bgHighlight())
            imageView.alpha = 0.0
            
            return imageView
        })
        let padding = 50.0
        for (index, highlight) in buttonHighlights.enumerated() {
            addSubview(highlight)
            let button = buttons[index]
            highlight.leftAnchor == button.leftAnchor - padding
            highlight.rightAnchor == button.rightAnchor + padding
            highlight.topAnchor == button.topAnchor - padding
            highlight.bottomAnchor == button.bottomAnchor
        }
        buttons.forEach { bringSubview(toFront: $0) }
    }
}

// MARK: - Actions

extension TabBarView {

    @objc func buttonPressed(_ button: UIButton) {
        guard titles.count > 1 else {
            return
        }

        let index = button.tag
        if setSelectedIndex(index, animated: true) {
            delegate?.didSelectItemAtIndex(index: index, sender: self)
        }
    }
}

// MARK: Sync Appearance

private extension TabBarView {

    func syncAppearance(animated: Bool) {
        syncButtonColors(animated: animated)
        layoutIndicatorView(animated: animated)
    }
    
    func syncButtonImages(animated: Bool) {
        let duration = Layout.TabBarView.animationDuration
        for (index, highlight) in buttonHighlights.enumerated() {
            if animated {
                UIView.animate(withDuration: duration, animations: {
                    highlight.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
                })
            } else {
                highlight.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
            }
        }
    }

    func syncButtonColors(animated: Bool) {
        if animated == true {
            for button in buttons {
                let color = selectedColor(for: button)
                let transition = UIViewAnimationOptions.transitionCrossDissolve
                let duration = Layout.TabBarView.animationDuration

                UIView.transition(with: button, duration: duration, options: transition, animations: {
                    button.setTitleColor(color, for: .normal)
                }, completion: nil)
            }
        } else {
            for button in buttons {
                button.setTitleColor(selectedColor(for: button), for: .normal)
            }
        }
    }

    func layoutButtons() {
        switch tabBarType.distribution(width: frame.width) {
        case .fillEqually: fillEquallyButtons()
        case .fillProportionally(let spacing): fillProportionally(spacing: spacing)
        }
    }
    
    func layoutIndicatorView(animated: Bool) {
        guard
            let selectedIndex = selectedIndex,
            selectedIndex < buttons.count || titles.count > 1 else {
                indicatorView.backgroundColor = .clear
                buttons.first?.setTitleColor(selectedColor, for: .normal)
                return
        }
        
        bringSubview(toFront: indicatorView)

        if animated == true {
            let transition = UIViewAnimationOptions.curveEaseInOut

            UIView.animate(withDuration: Layout.TabBarView.animationDuration, delay: 0, options: transition, animations: {
                self.indicatorView.frame = self.indicatorFrame(selectedIndex: selectedIndex)
            }, completion: nil)
        } else {
            indicatorView.frame = indicatorFrame(selectedIndex: selectedIndex)
        }
    }

    func selectedColor(for button: UIButton) -> UIColor {
        return button.tag == selectedIndex ? selectedColor : deselectedColor
    }

    func syncIndicatorViewColor() {
        indicatorView.backgroundColor = selectedIndex == nil ? .clear : selectedColor
    }
}

// MARK: - Private Helpers

private extension TabBarView {

    func indicatorFrame(selectedIndex: Index) -> CGRect {
        let button = buttons[selectedIndex]
        var width = indicatorViewExtendedWidth

        if let titleWidth = button.titleLabel?.intrinsicContentSize.width {
            width += titleWidth
        } else {
            width += button.intrinsicContentSize.width
        }

        let height: CGFloat = 1
        let x = button.center.x - (width / 2)
        let y = bounds.maxY - height

        return CGRect(x: x, y: y, width: width, height: height)
    }

    func fillEquallyButtons() {
        let width = bounds.width / CGFloat(buttons.count)

        buttons.enumerated().forEach { (index, button) in
            let x = CGFloat(index) * width
            button.frame = CGRect(x: x, y: 0, width: width, height: bounds.height).integral
        }
    }

    func fillProportionally(spacing: CGFloat) {
        let buttonWiths = buttons.map { $0.intrinsicContentSize.width }
        let totalSpacing = CGFloat(max(buttons.count - 1, 0)) * spacing
        let totoalWidth = buttonWiths.reduce(0, +)
        var x = (bounds.width - (totoalWidth + totalSpacing)) / 2

        for (width, button) in zip(buttonWiths, buttons) {
            button.frame = CGRect(x: x, y: 0, width: width, height: bounds.height).integral
            x += width + spacing
        }
    }
}

// MARK: Setup

private extension TabBarView {

    func setupHierachy() {
        addSubview(indicatorView)
    }
}
