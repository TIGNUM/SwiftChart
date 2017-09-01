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
    func viewDidAppear()
}

final class TabBarController: UIViewController {
    
    struct Item {
        let controller: UIViewController
        let title: String
    }

    fileprivate var selectedIndex: Int = 0
    fileprivate var items: [Item]
    fileprivate weak var currentViewController: UIViewController?
    fileprivate lazy var containerView = UIView()
    fileprivate weak var indicatorViewLeadingConstraint: NSLayoutConstraint?
    fileprivate weak var indicatorViewWidthConstraint: NSLayoutConstraint?
    fileprivate weak var tabBarBottomConstraint: NSLayoutConstraint?
    weak var delegate: TabBarControllerDelegate?

    var viewControllers: [UIViewController] {
        return items.map { $0.controller }
    }
    
    lazy var tabBarView: TabBarView = {
        let tabBarView = TabBarView(tabBarType: .bottom)
        tabBarView.setTitles(self.items.map { $0.title }, selectedIndex: self.selectedIndex)
        tabBarView.selectedColor = Layout.TabBarView.selectedButtonColor
        tabBarView.deselectedColor = Layout.TabBarView.deselectedButtonColor
        tabBarView.indicatorViewExtendedWidth = Layout.TabBarView.indicatorViewExtendedWidthBottom
        tabBarView.delegate = self
        tabBarView.backgroundColor = .clear

        tabBarView.buttons.forEach { (button: UIButton) in
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }

        return tabBarView
    }()

    init(items: [Item], selectedIndex: Index) {
        precondition(selectedIndex >= 0 && selectedIndex < items.count, "Out of bounds selectedIndex")

        self.selectedIndex = selectedIndex
        self.items = items
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupLayout()
        loadFirstView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.delegate?.viewDidAppear()
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
        containerView.bottomAnchor == tabBarView.bottomAnchor
        
        tabBarBottomConstraint = (tabBarView.bottomAnchor == view.bottomAnchor)
        tabBarView.horizontalAnchors == view.horizontalAnchors + Layout.TabBarView.stackViewHorizontalPaddingBottom
        tabBarView.heightAnchor == 64
        
        view.layoutIfNeeded()
    }
}

// MARK: - TabBarViewDelegate

extension TabBarController: TabBarViewDelegate {

    func didSelectItemAtIndex(index: Int, sender: TabBarView) {
        displayContentController(items[index].controller)
        delegate?.didSelectTab(at: index, in: self)
    }
}

// MARK: - ZoomPresentationAnimatable

extension TabBarController: ZoomPresentationAnimatable {
    func startAnimation(presenting: Bool, animationDuration: TimeInterval, openingFrame: CGRect) {
        tabBarBottomConstraint?.constant = presenting ? 0 : 64

        UIView.transition(with: self.view, duration: animationDuration, options: [.allowAnimatedContent, .curveEaseOut], animations: {
            self.tabBarBottomConstraint?.constant = presenting ? 64 : 0
            self.view.layoutIfNeeded()
        }, completion: nil)

        guard
            let currentVC = currentViewController as? ZoomPresentationAnimatable
            else { return }

        currentVC.startAnimation(presenting: presenting, animationDuration: animationDuration, openingFrame: openingFrame)
    }
}

// MARK: - CustomPresentationAnimatorDelegate {

extension TabBarController: CustomPresentationAnimatorDelegate {
    func animationsForAnimator(_ animator: CustomPresentationAnimator) -> (() -> Void)? {
        if let viewController = currentViewController as? CustomPresentationAnimatorDelegate {
            return viewController.animationsForAnimator(animator)
        }
        return nil
    }
}
