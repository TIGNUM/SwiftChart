//
//  TabBarController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
final class TabBarController: UIViewController {
    
    // MARK: - Properties
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
        view.distribution = .fillProportionally
        return view
    }()
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    } ()
    
    fileprivate lazy var indicatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private func makeButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.tag = index
        return button
    }
    
    fileprivate var selectedIndex: Index
    
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
        
        view.backgroundColor = .purple
        setupView()
        
        setupHierarchy()
        setupLayout()
        loadFirstView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        syncIndicatorView(forButton: stackView.arrangedSubviews[selectedIndex], animated: false)
    }
    
    @objc private func buttonPressed(_ button: UIButton) {
        displayContentController(items[button.tag].controller)
        syncIndicatorView(forButton: button, animated: true)

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
    
    private func setupView() {
        items.enumerated().forEach { (index, item) in
            let button = makeButton(title: item.title, index: index)
            stackView.addArrangedSubview(button)
        }
    }
    private func loadFirstView() {
        let controller = items[selectedIndex].controller
        addChildViewController(controller)
        controller.view.frame = containerView.frame
        containerView.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        currentViewController = controller
    }
    
    func syncIndicatorView(forButton button: UIView, animated: Bool) {
        let width = button.intrinsicContentSize.width + 16
        
        indicatorViewWidthConstraint?.constant = width
        indicatorViewLeadingConstraint?.constant = button.center.x - (width / 2)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        log("didSelect viewController: \(viewController)")
    }
}

extension TabBarController {
    func setupHierarchy() {
        view.addSubview(stackView)
        view.addSubview(containerView)
        view.addSubview(indicatorView)
    }
    
    func setupLayout() {
        containerView.topAnchor == view.topAnchor
        containerView.horizontalAnchors == view.horizontalAnchors
        containerView.bottomAnchor == stackView.topAnchor
        
        stackView.bottomAnchor == view.bottomAnchor
        stackView.leftAnchor == view.leftAnchor
        stackView.rightAnchor == view.rightAnchor
        stackView.heightAnchor == 64
        
        indicatorView.bottomAnchor == view.bottomAnchor
        indicatorView.heightAnchor == 1
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor == view.leadingAnchor
        indicatorViewWidthConstraint = indicatorView.widthAnchor == 0
        
        view.layoutIfNeeded()
    }
}
