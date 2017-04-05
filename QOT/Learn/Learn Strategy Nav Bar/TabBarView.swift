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
    weak var delegate: TabBarViewDelegate?
    struct Configuration {
        enum Distribution {
            case fillEqually
            case fillProportionally(spacing: CGFloat)
        }
        
        let titles: [String]
        let indicatorViewExtendedWidth: CGFloat
        let selectedColor: UIColor
        let deselectedColor: UIColor
        let distribution: Distribution
    }
    
    fileprivate var configuration: Configuration!
    
    var selectedIndex: Int!
    
    fileprivate var buttons: [UIButton]!
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillProportionally
        return view
    }()
    
    func setup(configuration: Configuration, selectedIndex: Int = 1) {
        guard self.configuration == nil else {
            preconditionFailure("TabBarView can only be setup once")
        }
        
        self.configuration = configuration
        self.selectedIndex = selectedIndex
        
        buttons = configuration.titles.enumerated().map { (index, title) in
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Font.TabBarController.buttonTitle
            button.backgroundColor = .clear
            button.setTitleColor(configuration.deselectedColor, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button.tag = index
            return button
        }
        
        indicatorView.backgroundColor = configuration.selectedColor
        
        setupHierachy()
        setupLayout()
        
        syncIndicatorView(animated: false)
        syncButtonColors(animated: false)
        
        switch configuration.distribution {
        case .fillEqually:
            stackView.spacing = 0
        case .fillProportionally(let spacing):
            stackView.spacing = spacing
        }
    }
    
    fileprivate weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    fileprivate weak var indicatorViewWidthConstraint: NSLayoutConstraint!
    fileprivate var stackViewLeadingConstraints: NSLayoutConstraint!
    
    enum Constants {
        static let animationDuration: TimeInterval = 0.3
        
    }
    
    fileprivate lazy var indicatorView: UIView! = UIView()
    
    @objc private func buttonPressed(_ button: UIButton) {
        
        guard button.tag != selectedIndex else {
            return
        }
        selectedIndex = button.tag
        delegate?.didSelectItemAtIndex(index: selectedIndex, sender: self)
        
        syncIndicatorView(animated: true)
        syncButtonColors(animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
  
        syncIndicatorView(animated: false)
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
        let button = buttons[selectedIndex]
        let width = button.intrinsicContentSize.width + configuration.indicatorViewExtendedWidth
        
        let center = stackView.convert(button.center, to: self)
        indicatorViewWidthConstraint?.constant = width
        indicatorViewLeadingConstraint?.constant = center.x - (width / 2)
        
        if animated {
            let transition = UIViewAnimationOptions.curveEaseInOut
            UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: transition, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            layoutIfNeeded()
        }
    }
    
    func selectedColor(for button: UIButton) -> UIColor {
        return button.tag == selectedIndex ? configuration.selectedColor : configuration.deselectedColor
    }
}

private extension TabBarView {
    
    func setupHierachy() {
        addSubview(stackView)
        buttons.forEach { stackView.addArrangedSubview($0) }
        addSubview(indicatorView)
    }
    
    func setupLayout() {
        indicatorView.heightAnchor == 1
        indicatorView.bottomAnchor == bottomAnchor
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor == leadingAnchor
        indicatorViewWidthConstraint = indicatorView.widthAnchor == 0
        
        stackView.verticalAnchors == verticalAnchors
        
        switch configuration.distribution {
        case .fillEqually:
            stackView.horizontalAnchors == horizontalAnchors
        case .fillProportionally:
            stackView.centerAnchors == centerAnchors
            
        }
        layoutIfNeeded()
    }
}
