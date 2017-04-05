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
    func didSelectItemAtIndex(index: Int?, sender: TabBarView)
}

class TabBarView: UIView {
    
    enum Constants {
        static let animationDuration: TimeInterval = 0.3
        
    }
    
    enum Distribution {
        case fillEqually
        case fillProportionally(spacing: CGFloat)
    }
    
    // MARK: Private properties
    
    fileprivate lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillProportionally
        return view
    }()
    
    fileprivate lazy var indicatorView: UIView = UIView()
    
    fileprivate var stackViewWidthConstraint: NSLayoutConstraint?
    
    fileprivate var titles: [String] = []
    
    fileprivate var buttons: [UIButton] = []
    
    // MARK: Public properties
    
    private(set) var selectedIndex: Int?
    
    var distribution: Distribution = .fillEqually {
        didSet {
            switch distribution {
            case .fillEqually:
                stackView.spacing = 0
                stackViewWidthConstraint?.isActive = true
            case .fillProportionally(let spacing):
                stackView.spacing = spacing
                stackViewWidthConstraint?.isActive = false
            }
            layoutIfNeeded()
            syncIndicatorView(animated: true)
        }
    }
    
    var selectedColor: UIColor = .black {
        didSet {
            syncButtonColors(animated: false)
        }
    }
    
    var deselectedColor: UIColor = UIColor.black.withAlphaComponent(0.4) {
        didSet {
            syncButtonColors(animated: false)
        }
    }
    
    weak var delegate: TabBarViewDelegate?
    
    var indicatorViewExtendedWidth: CGFloat = 0 {
        didSet {
            syncIndicatorView(animated: false)
        }
    }
    
    // MARK: Overides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupHierachy()
        setupLayout()
        syncIndicatorView(animated: false)
        syncButtonColors(animated: false)
        syncIndicatorViewColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        syncIndicatorView(animated: false)
    }
    
    // MARK: Public methods
    
    @objc private func buttonPressed(_ button: UIButton) {
        setSelectedIndex(button.tag, animated: true)
    }
    
    func setSelectedIndex(_ index: Int?, animated: Bool) {
        guard index != selectedIndex else {
            return
        }
        
        selectedIndex = index
        syncIndicatorView(animated: animated)
        syncButtonColors(animated: animated)
        syncIndicatorViewColor()
        
        delegate?.didSelectItemAtIndex(index: index, sender: self)
    }
    
    func setTitles(_ titles: [String], selectedIndex: Int?) {
        self.titles = titles
        
        syncButtonTitles()
        setSelectedIndex(selectedIndex, animated: false)
    }
    
    // MARK: Private methods
    
    private func syncButtonTitles() {
        buttons.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview() // A stack view oddity... removeArrangedSubview doesn't remove view from superview
        }
        
        buttons = titles.enumerated().map { (index, title) in
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Font.TabBarController.buttonTitle
            button.backgroundColor = .clear
            button.setTitleColor(deselectedColor, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button.tag = index
            return button
        }
        
        buttons.forEach { stackView.addArrangedSubview($0) }
    }
}

// MARK: Sync Appearance

private extension TabBarView {
    
    func syncAppearance(animated: Bool) {
        syncButtonColors(animated: animated)
        syncIndicatorView(animated: animated)
    }
    
    func syncButtonColors(animated: Bool) {
        if animated {
            for button in buttons {
                let color = selectedColor(for: button)
                let transition = UIViewAnimationOptions.transitionCrossDissolve
                let duration = Constants.animationDuration
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
    
    func syncIndicatorView(animated: Bool) {
        guard let selectedIndex = selectedIndex else {
            return
        }
        
        let button = buttons[selectedIndex]
        let center = stackView.convert(button.center, to: self)
        
        print(button.frame)
        print(stackView.frame)
        
        let width = button.intrinsicContentSize.width + indicatorViewExtendedWidth
        let height: CGFloat = 1
        let x = center.x - (width / 2)
        let y = bounds.maxY - height
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        if animated {
            let transition = UIViewAnimationOptions.curveEaseInOut
            UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: transition, animations: {
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
        addSubview(stackView)
        buttons.forEach { stackView.addArrangedSubview($0) }
        addSubview(indicatorView)
    }
    
    func setupLayout() {
        stackView.verticalAnchors == verticalAnchors
        stackView.centerAnchors == centerAnchors
        stackViewWidthConstraint = stackView.widthAnchor == widthAnchor
        
        layoutIfNeeded()
    }
}
