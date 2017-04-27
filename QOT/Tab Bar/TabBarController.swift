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
    fileprivate let tabBarView: TabBarView
    weak var delegate: TabBarControllerDelegate?

    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        return view
    } ()


    var viewControllers: [UIViewController] {
        return items.map { $0.controller }
    }
    
    init(items: [Item], selectedIndex: Index) {
        precondition(selectedIndex >= 0 && selectedIndex < items.count, "Out of bounds selectedIndex")
        
        let tabBarView = TabBarView(tabBarType: .bottom)
        tabBarView.setTitles(items.map { $0.title }, selectedIndex: 0)
        tabBarView.selectedColor = Constants.selectedButtonColor
        tabBarView.deselectedColor = Constants.deselectedButtonColor
        tabBarView.indicatorViewExtendedWidth = Constants.indicatorViewExtendedWidth        
        
        self.items = items
        self.tabBarView = tabBarView
        
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
        tabBarView.delegate = self
        tabBarView.buttons.forEach { (button) in
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
    }
    
    fileprivate func displayContentController(_ viewController: UIViewController) {
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
        guard let index = tabBarView.selectedIndex else {
            return
        }
        
        let controller = items[index].controller
        addChildViewController(controller)
        controller.view.frame = containerView.frame
        containerView.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        currentViewController = controller
    }
}

extension TabBarController {
    
    func setupHierarchy() {
        view.addSubview(containerView)
        view.addSubview(tabBarView)
    }
    
    func setupLayout() {
        containerView.topAnchor == view.topAnchor
        containerView.horizontalAnchors == view.horizontalAnchors
        containerView.bottomAnchor == tabBarView.topAnchor
        
        tabBarView.bottomAnchor == view.bottomAnchor
        tabBarView.horizontalAnchors == view.horizontalAnchors + Constants.stackViewHorizontalPadding
        tabBarView.heightAnchor == 64
        
        view.layoutIfNeeded()
    }
}

extension TabBarController: TabBarViewDelegate {

    func didSelectItemAtIndex(index: Int?, sender: TabBarView) {
        guard let index = index else {
            return
        }
        
        displayContentController(items[index].controller)
        delegate?.didSelectTab(at: index, in: self)
    }
}
