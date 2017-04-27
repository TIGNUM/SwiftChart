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
        let controllers: [UIViewController]
        let titles: [String]
        let containsScrollView: Bool
        let contentView: UIView?

        init(
            controllers: [UIViewController],
            titles: [String],
            containsScrollView: Bool = false,
            contentView: UIView? = nil
            ) {
                self.containsScrollView = containsScrollView
                self.contentView = contentView
                self.titles = titles
                self.controllers = controllers
        }
    }

    // MARK: Properties

    fileprivate var item: Item
    fileprivate var tabBarView: TabBarView = TabBarView()
    fileprivate var index: Int = 0
    fileprivate var scrollViewContentOffset: CGFloat = 0
    weak var delegate: TopTabBarDelegate?

    fileprivate lazy var navigationItemBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    fileprivate lazy var leftButton: UIButton = {
        return self.button(with: #selector(leftButtonPressed(_:)))
    }()
    
    fileprivate lazy var rightButton: UIButton = {
        return self.button(with: #selector(rightButtonPressed(_:)))
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false

        return scrollView
    }()

    // MARK: - Init
    
    init(item: Item, selectedIndex: Index = 0, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {
        precondition(selectedIndex >= 0 && selectedIndex < item.controllers.count, "Out of bounds selectedIndex")

        self.item = item
        
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarView = self.setupTabBarView(selectedIndex: selectedIndex)
        self.setupButtons(leftIcon: leftIcon, rightIcon: rightIcon)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        addContentView()
        setupScrollView()
        tabBarView.delegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        setupScrollView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupLayout()
    }
}

// MARK: - Private Helpers

private extension TopTabBarController {

    func button(with action: Selector) -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: action, for: .touchUpInside)

        return button
    }
}

// MARK: - Setup Views

private extension TopTabBarController {

    func setupTabBarView(selectedIndex: Index) -> TabBarView {
        let tabBarView = TabBarView()
        tabBarView.setTitles(item.titles, selectedIndex: selectedIndex)
        tabBarView.selectedColor = Constants.selectedButtonColor
        tabBarView.deselectedColor = Constants.deselectedButtonColor
        tabBarView.indicatorViewExtendedWidth = Constants.indicatorViewExtendedWidth

        return tabBarView
    }

    func setupButtons(leftIcon: UIImage?, rightIcon: UIImage?) {
        leftButton.setImage(leftIcon, for: .normal)
        rightButton.setImage(rightIcon, for: .normal)
        leftButton.isHidden = leftIcon == nil
        rightButton.isHidden = rightIcon == nil
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

    func setupScrollView() {
        guard item.containsScrollView == false else {
            let halfContentSize = scrollView.contentSize.width * 0.5
            let offset = view.bounds.size.width - halfContentSize
            scrollViewContentOffset = halfContentSize - offset

            return
        }

        let width: CGFloat = view.bounds.width
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: CGFloat(item.controllers.count) * width, height: 0)
        scrollViewContentOffset = scrollView.bounds.size.width

        for (index, controller) in item.controllers.enumerated() {
            addViewToScrollView(controller)
            controller.view.frame.origin = CGPoint(x: CGFloat(index) * width, y: 0)
        }
    }

    func addViewToScrollView(_ viewController: UIViewController) {
        viewController.view.frame = view.frame
        scrollView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        addChildViewController(viewController)
    }
}

// MARK: - ScrollView Delegate

extension TopTabBarController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tabBarView.setSelectedIndex(scrollView.currentPage, animated: true)
    }
}

extension TopTabBarController: ContentScrollViewDelegate {

    func didEndDecelerating(_ contentOffset: CGPoint) {
        if contentOffset.equalTo(.zero) == true {
            tabBarView.setSelectedIndex(0, animated: true)
        } else {
            tabBarView.setSelectedIndex(1, animated: true)
        }
    }
}

// MARK: - Layout

private extension TopTabBarController {
    
    func setupHierarchy() {
        view.addSubview(navigationItemBar)
        navigationItemBar.addSubview(leftButton)
        navigationItemBar.addSubview(rightButton)
        navigationItemBar.addSubview(tabBarView)
    }

    func addContentView() {
        if item.containsScrollView == true,
            let contentView = item.contentView {
                view.addSubview(contentView)
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

        if item.containsScrollView == true,
            let contentView = item.contentView {
                setContentViewAnchors(contentView: contentView)
        } else {
            setScrollViewAnchors()
        }

        view.layoutIfNeeded()
    }

    private func setScrollViewAnchors() {
        scrollView.horizontalAnchors == view.horizontalAnchors
        scrollView.topAnchor == navigationItemBar.bottomAnchor
        scrollView.bottomAnchor == view.bottomAnchor
    }

    private func setContentViewAnchors(contentView: UIView) {
        contentView.horizontalAnchors == view.horizontalAnchors
        contentView.topAnchor == navigationItemBar.bottomAnchor
        contentView.bottomAnchor == view.bottomAnchor
    }
}

// MARK: - TabBarViewDelegate

extension TopTabBarController: TabBarViewDelegate {
    
    func didSelectItemAtIndex(index: Int?, sender: TabBarView) {
        guard let index = index else {
            return
        }
        
        self.index = index

        guard index != scrollView.currentPage else {
            return
        }

        let offset = CGPoint(x: scrollViewContentOffset * CGFloat(index), y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
}
