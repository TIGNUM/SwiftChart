//
//  TabBarController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol TabBarControllerDelegate: class {
    func didSelectTab(at index: Index, in controller: TabBarController)
}

final class TabBarController: UIViewController {
    
    struct Constants {
        static let animationDuration: TimeInterval = 0.3
        static let selectedButtonColor: UIColor = .white
        static let deselectedButtonColor: UIColor = UIColor.white.withAlphaComponent(0.4)
        static let stackViewHorizontalPadding: CGFloat = 16
        static let indicatorViewExtendedWidth: CGFloat = 16
    }
    
    struct Item {
        let controller: UIViewController
        let title: String
    }
    
    fileprivate var items: [Item]
    fileprivate weak var currentViewController: UIViewController?
    fileprivate weak var indicatorViewLeadingConstraint: NSLayoutConstraint?
    fileprivate weak var indicatorViewWidthConstraint: NSLayoutConstraint?
    
    fileprivate lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        return view
    } ()
    
    fileprivate lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var buttons: [UIButton] = {
        return self.items.enumerated().map { (index, item) in
            let button = UIButton(type: .custom)
            button.setTitle(item.title, for: .normal)
            button.titleLabel?.font = Font.TabBarController.buttonTitle
            button.backgroundColor = .clear
            button.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .normal)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button.tag = index
            return button
        }
    }()
    
    fileprivate var selectedIndex: Index
    
    weak var delegate: TabBarControllerDelegate?
    var viewControllers: [UIViewController] {
        return items.map { $0.controller }
    }
    
    init(items: [Item], selectedIndex: Index) {
        precondition(selectedIndex >= 0 && selectedIndex < items.count, "Out of bounds selectedIndex")
        
        self.items = items
        self.selectedIndex = selectedIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupHierarchy()
        setupLayout()
        
        loadFirstView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        syncIndicatorView(animated: false)
        syncButtonColors(animated: false)
    }
    
    @objc private func buttonPressed(_ button: UIButton) {
        guard button.tag != selectedIndex else {
            return
        }
        
        selectedIndex = button.tag
        displayContentController(items[button.tag].controller)
        syncIndicatorView(animated: true)
        syncButtonColors(animated: true)
        
        delegate?.didSelectTab(at: selectedIndex, in: self)
    }
    
    private func displayContentController(_ viewController: UIViewController) {
        if let existing = currentViewController {
            existing.willMove(toParentViewController: nil)
            existing.view.removeFromSuperview()
            existing.removeFromParentViewController()
        }
        
        addChildViewController(viewController)
        viewController.view.frame = containerView.frame
        containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        currentViewController = viewController
    }
    
    private func loadFirstView() {
        let controller = items[selectedIndex].controller
        addChildViewController(controller)
        controller.view.frame = containerView.frame
        containerView.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        currentViewController = controller
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
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            view.layoutIfNeeded()
        }
    }
}

extension TabBarController {
    
    func setupHierarchy() {
        view.addSubview(containerView)
        view.addSubview(indicatorView)
        view.addSubview(stackView)
        
        buttons.forEach { stackView.addArrangedSubview($0) }
    }
    
    func setupLayout() {
        containerView.topAnchor == view.topAnchor
        containerView.horizontalAnchors == view.horizontalAnchors
        containerView.bottomAnchor == stackView.topAnchor
        
        stackView.bottomAnchor == view.bottomAnchor - 10
        stackView.horizontalAnchors == view.horizontalAnchors + Constants.stackViewHorizontalPadding
        stackView.heightAnchor == 54
        
        indicatorView.bottomAnchor == view.bottomAnchor
        indicatorView.heightAnchor == 1
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor == view.leadingAnchor
        indicatorViewWidthConstraint = indicatorView.widthAnchor == 0
        
        view.layoutIfNeeded()
    }
}
