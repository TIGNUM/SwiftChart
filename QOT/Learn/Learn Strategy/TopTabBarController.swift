//
//  TopTabBarController.swift
//  QOT
//
//  Created by tignum on 4/5/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol TopTabBarDelegate: class {
    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController)
    func didSelectLeftButton(leftButtonTag: Int?, sender: TopTabBarController)
    func didSelectrightButton(rightButtonTag: Int?, sender: TopTabBarController)
}

final class TopTabBarController: UIViewController {
    
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
    
    // MARK: Private Objects
    
    fileprivate var controllers = [UIViewController]()
    
    fileprivate lazy var navigationItemBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    fileprivate lazy var leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(leftButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(rightButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    fileprivate var items: [Item]
    fileprivate let tabBarView: TabBarView
    fileprivate weak var delegate: TabBarControllerDelegate?
    
    // MARK: Public Objects
    
    var index: Int = 0
    var viewControllers: [UIViewController] {
        return items.map { $0.controller }
    }
    
    init(items: [Item], selectedIndex: Index, leftIcon: UIImage?, rightIcon: UIImage?) {
        precondition(selectedIndex >= 0 && selectedIndex < items.count, "Out of bounds selectedIndex")
        
        let tabBarView = TabBarView()
        tabBarView.setTitles(items.map { $0.title }, selectedIndex: 0)
        tabBarView.selectedColor = Constants.selectedButtonColor
        tabBarView.deselectedColor = Constants.deselectedButtonColor
        tabBarView.indicatorViewExtendedWidth = Constants.indicatorViewExtendedWidth
        
        self.items = items
        self.tabBarView = tabBarView
        
        super.init(nibName: nil, bundle: nil)
        if leftIcon != nil {
            leftButton.setImage(leftIcon, for: .normal) } else {leftButton.isHidden = true}
        if rightIcon != nil {
            rightButton.setImage(rightIcon, for: .normal) } else {rightButton.isHidden = true}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupScrollView()
        tabBarView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupScrollView()
    }
    
    func leftButtonPressed(_ button: UIButton) {
        
    }
    
    func rightButtonPressed(_ button: UIButton) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    func setupScrollView() {
        let width: CGFloat = view.bounds.width
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: CGFloat(items.count) * width, height: 0)
        
        for (index, item) in items.enumerated() {
            let vc = item.controller
            addViewToScrollView(vc)
            vc.view.frame.origin =  CGPoint(x: CGFloat(index) * width, y: 0)
        }
    }
    
    func addViewToScrollView(_ viewController: UIViewController) {
        scrollView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        addChildViewController(viewController)
    }
}

extension TopTabBarController {
    
    func setupHierarchy() {
        view.addSubview(navigationItemBar)
        navigationItemBar.addSubview(leftButton)
        navigationItemBar.addSubview(rightButton)
        navigationItemBar.addSubview(tabBarView)
        view.addSubview(scrollView)
    }
    
    func setupLayout() {
        navigationItemBar.horizontalAnchors == view.horizontalAnchors
        navigationItemBar.topAnchor == view.topAnchor
        navigationItemBar.heightAnchor == 64
        
        leftButton.leftAnchor == navigationItemBar.leftAnchor
        leftButton.bottomAnchor == navigationItemBar.bottomAnchor
        leftButton.topAnchor == navigationItemBar.topAnchor + 20
        leftButton.widthAnchor == 36
        
        rightButton.rightAnchor == navigationItemBar.rightAnchor
        rightButton.bottomAnchor == navigationItemBar.bottomAnchor
        rightButton.heightAnchor == leftButton.heightAnchor
        rightButton.widthAnchor == leftButton.widthAnchor
        
        tabBarView.leftAnchor == leftButton.rightAnchor
        tabBarView.rightAnchor == rightButton.leftAnchor
        tabBarView.topAnchor == navigationItemBar.topAnchor + 20
        tabBarView.bottomAnchor == navigationItemBar.bottomAnchor
        
        scrollView.horizontalAnchors == view.horizontalAnchors
        scrollView.topAnchor == navigationItemBar.bottomAnchor
        scrollView.bottomAnchor == view.bottomAnchor
        
        view.layoutIfNeeded()
    }
}

extension TopTabBarController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tabBarView.setSelectedIndex(scrollView.currentPage, animated: true)
    }
}

extension TopTabBarController: TabBarViewDelegate {
    
    func didSelectItemAtIndex(index: Int?, sender: TabBarView) {
        guard let index = index else {
            return
        }
        
        self.index = index
        if index != scrollView.currentPage {
            let offset = CGPoint(x: scrollView.bounds.size.width * CGFloat(index), y: 0)
            scrollView.setContentOffset(offset, animated: true)
        }
    }
}

private extension UIScrollView {
    
    var currentPage: Int {
        return Int(round(self.contentOffset.x / self.bounds.size.width))
    }
}
