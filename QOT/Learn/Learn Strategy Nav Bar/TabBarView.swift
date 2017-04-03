//
//  TabBarView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/3/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class TabBarView: UIView {
    
    struct Configuration {
        let titles: [String]
        let indicatorViewExtendedWidth: CGFloat
        let selectedColor: UIColor
        let deselectedColor: UIColor
        let edgeInsets: UIEdgeInsets
    }
    
    fileprivate var configuration: Configuration!
    fileprivate var selectedIndex: Int!
    fileprivate var buttons: [UIButton]!
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    func setup(configuration: Configuration, selectedIndex: Int = 0) {
        guard self.configuration == nil else {
            preconditionFailure("TabBarView can only be setup once")
        }
        
        self.configuration = configuration
        self.selectedIndex = selectedIndex
        
        buttons = configuration.titles.enumerated().map { (index, title) in
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Font.TabBarController.buttonTitle
            button.backgroundColor = .red
            button.setTitleColor(configuration.deselectedColor, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button.tag = index
            return button
        }
        
        indicatorView.backgroundColor = configuration.selectedColor
        
        setupHierachy()
        setupLayout()
        stackViewPadding()
        let button = buttons[selectedIndex]
        let width = button.intrinsicContentSize.width + configuration.indicatorViewExtendedWidth
        syncIndicatorView(animated: false, width: width)
        syncButtonColors(animated: false)
    }
    
    fileprivate weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    fileprivate weak var indicatorViewWidthConstraint: NSLayoutConstraint!
    fileprivate var edgeConstraints: EdgeGroup!
    
    enum Constants {
        static let animationDuration: TimeInterval = 0.3
        
    }
    
    fileprivate lazy var indicatorView: UIView! = UIView()
    
    @objc private func buttonPressed(_ button: UIButton) {
        
        guard button.tag != selectedIndex else {
            return
        }
        selectedIndex = button.tag
        let width = button.intrinsicContentSize.width + configuration.indicatorViewExtendedWidth
        syncIndicatorView(animated: true, width: width)
        syncButtonColors(animated: true)
    }
    
    func syncButtonColors(animated: Bool) {
        let getColor: (UIButton, Int) -> UIColor = { (button, index) in
            index == button.tag ? self.configuration.selectedColor : self.configuration.deselectedColor
        }
        
        if animated {
            for button in buttons {
                let color = getColor(button, selectedIndex)
                let transition = UIViewAnimationOptions.transitionCrossDissolve
                let duration = Constants.animationDuration
                UIView.transition(with: button, duration: duration, options: transition, animations: {
                    button.setTitleColor(color, for: .normal)
                }, completion: nil)
            }
        } else {
            for button in buttons {
                button.setTitleColor(getColor(button, selectedIndex), for: .normal)
            }
        }
    }
    
    func syncIndicatorView(animated: Bool, width: CGFloat) {
        let button = buttons[selectedIndex]
        
        indicatorViewWidthConstraint?.constant = width
        indicatorViewLeadingConstraint?.constant = button.center.x - (width / 2) + edgeConstraints.leading.constant
        
        if animated {
            let transition = UIViewAnimationOptions.curveEaseInOut
            UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: transition, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            layoutIfNeeded()
        }
    }
    
    func stackViewPadding() {
    
    }
}

private extension TabBarView {
    
    func setupHierachy() {
        addSubview(stackView)
        buttons.forEach { stackView.addArrangedSubview($0) }
        addSubview(indicatorView)
    }
    
    func setupLayout() {
        
        indicatorView.bottomAnchor == bottomAnchor
        indicatorView.heightAnchor == 1
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor == leadingAnchor
        indicatorViewWidthConstraint = indicatorView.widthAnchor == 0
        
        edgeConstraints = stackView.edgeAnchors == edgeAnchors
        
        layoutIfNeeded()
    }
}
