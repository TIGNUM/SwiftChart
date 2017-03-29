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
    fileprivate let selectedIndex: Index
    
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
    
    private func makeButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.tag = index
        return button
    }
    
    init(items: [Item], selectedIndex: Index) {
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
    }
    
    @objc private func buttonPressed(_ button: UIButton) {
        displayContentController(items[button.tag].controller)
    }
    
    private func displayContentController(_ viewController: UIViewController) {
        if containerView.subviews.count > 0 {
            viewController.willMove(toParentViewController: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
        addChildViewController(viewController)
        viewController.view.frame = containerView.frame
        containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    private func setupView() {
        items.enumerated().forEach { (index, item) in
            let button = makeButton(title: item.title, index: index)
            stackView.addArrangedSubview(button)
        }
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
    }
    
    func setupLayout() {
        containerView.topAnchor == view.topAnchor
        containerView.horizontalAnchors == view.horizontalAnchors
        containerView.bottomAnchor == stackView.topAnchor
        
        stackView.bottomAnchor == view.bottomAnchor
        stackView.leftAnchor == view.leftAnchor
        stackView.rightAnchor == view.rightAnchor
        stackView.heightAnchor == 64
        
        view.layoutIfNeeded()
    }
}
