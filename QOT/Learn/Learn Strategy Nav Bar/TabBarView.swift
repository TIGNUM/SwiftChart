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
    
    var titles: [String] = ["Full", "Short", "New"]
    var selectedIndex: Int = 0
    fileprivate weak var indicatorViewLeadingConstraint: NSLayoutConstraint?
    fileprivate weak var indicatorViewWidthConstraint: NSLayoutConstraint?
    
    struct Constants {
        static let animationDuration: TimeInterval = 0.3
        static let selectedButtonColor: UIColor = .white
        static let deselectedButtonColor: UIColor = UIColor.white.withAlphaComponent(0.4)
        static let stackViewHorizontalPadding: CGFloat = 16
        static let indicatorViewExtendedWidth: CGFloat = 16
    }
    
    fileprivate lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    fileprivate lazy var buttons: [UIButton] = {
        return self.titles.enumerated().map { (index, title) in
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Font.TabBarController.buttonTitle
            button.backgroundColor = .clear
            button.setTitleColor(Constants.deselectedButtonColor, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button.tag = index
            return button
        }
    }()
    
    fileprivate lazy var indicatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func awakeFromNib() {
        self.backgroundColor = .black
       print("hello")
        setupHierachy()
        setupLayout()
        syncIndicatorView(animated: true)
        syncButtonColors(animated: true)
    }
    
    @objc private func buttonPressed(_ button: UIButton) {
       
        guard button.tag != selectedIndex else {
            return
        }
        selectedIndex = button.tag
        syncIndicatorView(animated: true)
        syncButtonColors(animated: true)
    }
    
    func syncButtonColors(animated: Bool) {
        let getColor: (UIButton, Int) -> UIColor = { (button, index) in
            index == button.tag ? Constants.selectedButtonColor : Constants.deselectedButtonColor
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
    
    func syncIndicatorView(animated: Bool) {
        let button = buttons[selectedIndex]
        let width = button.intrinsicContentSize.width + Constants.indicatorViewExtendedWidth
        
        indicatorViewWidthConstraint?.constant = width
        indicatorViewLeadingConstraint?.constant = button.center.x - (width / 2) + Constants.stackViewHorizontalPadding
        
        if animated {
            let transition = UIViewAnimationOptions.curveEaseInOut
            UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: transition, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            layoutIfNeeded()
        }
    }
}

private extension TabBarView {
    
    func setupHierachy() {
        addSubview(stackView)
         buttons.forEach { stackView.addArrangedSubview($0) }
        addSubview(indicatorView)
    }
    
    func setupLayout() {
        stackView.topAnchor == topAnchor
        stackView.bottomAnchor == bottomAnchor
        stackView.leftAnchor == leftAnchor
        stackView.rightAnchor == rightAnchor
        
        indicatorView.bottomAnchor == bottomAnchor
        indicatorView.heightAnchor == 1
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor == leadingAnchor
        indicatorViewWidthConstraint = indicatorView.widthAnchor == 0
        
        layoutIfNeeded()
        
    }
}
