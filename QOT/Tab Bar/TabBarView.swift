//
//  TabBarView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/3/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol TabBarViewDelegate: class {
    func didSelectItemAtIndex(index: Int?, sender: TabBarView)
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
            case .top: return Font.H6NavigationTitle
            }
        }
    }

    // MARK: Private properties

    fileprivate lazy var indicatorView: UIView = UIView()
    fileprivate var stackViewWidthConstraint: NSLayoutConstraint?
    fileprivate var titles = [String]()
    fileprivate let tabBarType: TabBarType

    // MARK: Public properties

    private(set) var selectedIndex: Int?
    private(set) var buttons = [UIButton]()
    weak var delegate: TabBarViewDelegate?

    var distribution: Distribution = .fillEqually {
        didSet {
            setNeedsLayout()
        }
    }

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

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        setup()
//    }

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

    @objc private func buttonPressed(_ button: UIButton) {
        let index = button.tag
        setSelectedIndex(index, animated: true)
        delegate?.didSelectItemAtIndex(index: index, sender: self)
    }

    func setSelectedIndex(_ index: Int?, animated: Bool) {
        guard index != selectedIndex else {
            return
        }

        selectedIndex = index
        layoutIndicatorView(animated: animated)
        syncButtonColors(animated: animated)
        syncIndicatorViewColor()
    }

    func setTitles(_ titles: [String], selectedIndex: Int?) {
        self.titles = titles

        setNeedsLayout()
        syncButtonTitles()
        setSelectedIndex(selectedIndex, animated: false)
    }

    // MARK: Private methods

    private func syncButtonTitles() {
        buttons.forEach { $0.removeFromSuperview() }

        buttons = titles.enumerated().map { (index, title) in
            let button = UIButton(type: .custom)
            button.setTitle(title.uppercased(), for: .normal)
            button.titleLabel?.font = Font.H5SecondaryHeadline
            button.backgroundColor = .clear
            button.setTitleColor(deselectedColor, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button.tag = index

            return button
        }

        buttons.forEach { addSubview($0) }
    }
}

// MARK: Sync Appearance

private extension TabBarView {

    func syncAppearance(animated: Bool) {
        syncButtonColors(animated: animated)
        layoutIndicatorView(animated: animated)
    }

    func syncButtonColors(animated: Bool) {
        if animated {
            for button in buttons {
                let color = selectedColor(for: button)
                let transition = UIViewAnimationOptions.transitionCrossDissolve
                let duration = Animation.tabBarViewAnimationDuration

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
        switch distribution {
        case .fillEqually:
            let width = bounds.width / CGFloat(buttons.count)

            buttons.enumerated().forEach { (index, button) in
                let x = CGFloat(index) * width
                button.frame = CGRect(x: x, y: 0, width: width, height: bounds.height).integral
            }
        case .fillProportionally(let spacing):
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

    func layoutIndicatorView(animated: Bool) {
        guard
            let selectedIndex = selectedIndex,
            selectedIndex < buttons.count else {
                return
        }

        let button = buttons[selectedIndex]
        let width = button.intrinsicContentSize.width + indicatorViewExtendedWidth
        let height: CGFloat = 1
        let x = button.center.x - (width / 2)
        let y = bounds.maxY - height
        let frame = CGRect(x: x, y: y, width: width, height: height)

        if animated == true {
            let transition = UIViewAnimationOptions.curveEaseInOut
            UIView.animate(withDuration: Animation.tabBarViewAnimationDuration, delay: 0, options: transition, animations: {
                self.indicatorView.frame = frame
            }, completion: nil)
        } else {
            indicatorView.frame = frame
        }
    }

    func selectedColor(for button: UIButton) -> UIColor {
        return button.tag == selectedIndex ? selectedColor : deselectedColor
    }

    func syncIndicatorViewColor() {
        if selectedIndex == nil {
            indicatorView.backgroundColor = .clear
        } else {
            indicatorView.backgroundColor = selectedColor
        }
    }
}

// MARK: Setup

private extension TabBarView {

    func setupHierachy() {
        addSubview(indicatorView)
    }
}
