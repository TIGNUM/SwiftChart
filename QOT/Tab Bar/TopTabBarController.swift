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
    func didSelectLeftButton(sender: TopTabBarController)
    func didSelectRightButton(sender: TopTabBarController)
}

final class TopTabBarController: UIViewController {

    // MARK: - Constants
    
    struct Constants {
        static let animationDuration: TimeInterval = 0.3
        static let selectedButtonColor: UIColor = .white
        static let deselectedButtonColor: UIColor = UIColor.white.withAlphaComponent(0.4)
        static let stackViewHorizontalPadding: CGFloat = 16
        static let indicatorViewExtendedWidth: CGFloat = 16
    }
    
    // MARK: - TopTabBarController Item

    struct Item {
        let controller: UIViewController
        let title: String
    }

    // MARK: - TopTabBarController MyUniverse

    struct MyUniverseItem {
        let controller: MyUniverseViewController
        let titles: [String]
    }

    // MARK: Properties

    fileprivate var controllers = [UIViewController]()
    fileprivate let items: [Item]
    fileprivate lazy var myUniverseItem: MyUniverseItem? = nil
    fileprivate let tabBarView: TabBarView
    fileprivate var index: Int = 0
    weak var delegate: TopTabBarDelegate?

    fileprivate lazy var navigationItemBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
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

//    fileprivate var viewControllers: [UIViewController] {
//        return items.map { $0.controller }
//    }

    // MARK: - Init
    
    init(items: [Item], selectedIndex: Index, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {
        precondition(selectedIndex >= 0 && selectedIndex < items.count, "Out of bounds selectedIndex")
        
        let tabBarView = TabBarView()
        tabBarView.setTitles(items.map { $0.title }, selectedIndex: selectedIndex)
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

    init(myUniverseItem: MyUniverseItem, selectedIndex: Index, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {
        precondition(selectedIndex >= 0 && selectedIndex < myUniverseItem.titles.count, "Out of bounds selectedIndex")

        let tabBarView = TabBarView()
        tabBarView.setTitles(myUniverseItem.titles, selectedIndex: selectedIndex)
        tabBarView.selectedColor = Constants.selectedButtonColor
        tabBarView.deselectedColor = Constants.deselectedButtonColor
        tabBarView.indicatorViewExtendedWidth = Constants.indicatorViewExtendedWidth

        self.items = []
        self.tabBarView = tabBarView

        super.init(nibName: nil, bundle: nil)
        self.myUniverseItem = myUniverseItem

        if leftIcon != nil {
            leftButton.setImage(leftIcon, for: .normal) } else {leftButton.isHidden = true}
        if rightIcon != nil {
            rightButton.setImage(rightIcon, for: .normal) } else {rightButton.isHidden = true}
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
//        setupScrollViewIfNeeded()
        setupScrollView()
        tabBarView.delegate = self
        view.backgroundColor = .brown
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        setupScrollView()
//        setupScrollViewIfNeeded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayout()
    }
}

// MARK: - Actions

extension TopTabBarController {

    func leftButtonPressed(_ button: UIButton) {
        delegate?.didSelectLeftButton(sender: self)
    }

    func rightButtonPressed(_ button: UIButton) {
        delegate?.didSelectRightButton(sender: self)
    }
}

// MARK: - ScrollView

extension TopTabBarController {

//    func setupScrollViewIfNeeded() {
//        if let myUniverseItem = myUniverseItem {
//            addMyUniverseViewAsChild(myUniverseItem.controller)
//        } else {
//            setupScrollView()
//        }
//    }

    func setupScrollView() {
        if let myUniverseScrollView = myUniverseItem?.controller.contentScrollView {
            scrollView = myUniverseScrollView
//            scrollView.delegate = self
        } else {
            let width: CGFloat = view.bounds.width
            scrollView.frame = view.bounds
            scrollView.contentSize = CGSize(width: CGFloat(items.count) * width, height: 0)

            for (index, item) in items.enumerated() {
                let vc = item.controller
                addViewToScrollView(vc)
                vc.view.frame.origin = CGPoint(x: CGFloat(index) * width, y: 0)
            }
        }
    }

    private func addViewToScrollView(_ viewController: UIViewController) {
        viewController.view.frame = view.frame
        scrollView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        addChildViewController(viewController)
    }

//    private func addMyUniverseViewAsChild(_ myUniverseController: MyUniverseViewController) {
//        myUniverseController.didMove(toParentViewController: self)
//        addChildViewController(myUniverseController)
//    }
}

// MARK: - ScrollView Delegate

extension TopTabBarController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tabBarView.setSelectedIndex(scrollView.currentPage, animated: true)
    }
}

// MARK: - Layout

private extension TopTabBarController {
    
    func setupHierarchy() {
        view.addSubview(navigationItemBar)
        navigationItemBar.addSubview(leftButton)
        navigationItemBar.addSubview(rightButton)
        navigationItemBar.addSubview(tabBarView)
        addContentView()
    }

    private func addContentView() {
        if let myUniverseItem = myUniverseItem {
            view.addSubview(myUniverseItem.controller.view)
        } else {
            view.addSubview(scrollView)
        }
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

        if let myUniverseItem = myUniverseItem {
            setMyUniverseViewAnchors(myUniverseItem: myUniverseItem)
        } else {
            setScrollViewAnchors()
        }

        view.layoutIfNeeded()
    }

    private func setScrollViewAnchors() {
        scrollView.horizontalAnchors == view.horizontalAnchors
        scrollView.topAnchor == navigationItemBar.bottomAnchor
        scrollView.bottomAnchor == view.bottomAnchor

        scrollView.backgroundColor = .purple
    }

    private func setMyUniverseViewAnchors(myUniverseItem: MyUniverseItem) {
        myUniverseItem.controller.view.horizontalAnchors == view.horizontalAnchors
        myUniverseItem.controller.view.topAnchor == navigationItemBar.bottomAnchor
        myUniverseItem.controller.view.bottomAnchor == view.bottomAnchor
    }
}

// MARK: - TabBarViewDelegate

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
