//
//  TopTabBarController.swift
//  QOT
//
//  Created by tignum on 4/5/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

enum Theme {
    case dark
    case darkClear
    case light

    var selectedColor: UIColor {
        switch self {
        case .dark,
             .darkClear: return Layout.TabBarView.selectedButtonColor
        case .light: return Layout.TabBarView.selectedButtonColorLightTheme
        }
    }

    var deselectedColor: UIColor {
        switch self {
        case .dark,
             .darkClear: return Layout.TabBarView.deselectedButtonColor
        case .light: return Layout.TabBarView.deselectedButtonColorLightTheme
        }
    }

    var navigationBarBackgroundColor: UIColor {
        switch self {
        case .dark: return Color.navigationBarDark
        case .darkClear: return .clear
        case .light: return UIColor.white.withAlphaComponent(0.825)
        }
    }

    var scrollViewBackgroundColor: UIColor {
        switch self {
        case .dark,
             .darkClear: return .clear
        case .light: return .white
        }
    }
}

protocol TopTabBarDelegate: class {
    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController)
    func didSelectLeftButton(sender: TopTabBarController)
    func didSelectRightButton(sender: TopTabBarController)
}

final class TopTabBarController: UIViewController {

    // MARK: - TopTabBarController Item

    struct Item {
        let controllers: [UIViewController]
        let titles: [String]
        let themes: [Theme]
        let containsScrollView: Bool
        let enableTabScrolling: Bool
        let contentView: UIView?

        init(
            controllers: [UIViewController],
            themes: [Theme],
            titles: [String] = [],
            containsScrollView: Bool = false,
            enableTabScrolling: Bool = true,
            contentView: UIView? = nil) {
                self.containsScrollView = containsScrollView
                self.enableTabScrolling = enableTabScrolling
                self.contentView = contentView
                self.titles = titles
                self.controllers = controllers
                self.themes = themes
        }

        func controller(at index: Index) -> UIViewController {
            return controllers[index]
        }

        func theme(at index: Index) -> Theme {
            return themes[index]
        }
    }

    // MARK: Properties

    fileprivate var selectedIndex: Int = 0
    fileprivate var previousIndex: Int = 0
    fileprivate lazy var currentView: UIView = UIView()
    fileprivate lazy var nextView: UIView = UIView()
    fileprivate var scrollViewContentOffset: CGFloat = 0
    var item: Item
    weak var delegate: TopTabBarDelegate?

    fileprivate lazy var navigationItemBar: UIView = {
        let view = UIView()
        view.backgroundColor = self.item.theme(at: self.selectedIndex).navigationBarBackgroundColor

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
        scrollView.backgroundColor = self.item.theme(at: self.selectedIndex).scrollViewBackgroundColor
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false

        return scrollView
    }()

    fileprivate lazy var tabBarView: TabBarView = {
        let tabBarView = TabBarView(tabBarType: .top)
        tabBarView.setTitles(self.item.titles, selectedIndex: self.item.titles.count == 1 ? nil : 0)
        tabBarView.selectedColor = self.item.theme(at: self.selectedIndex).selectedColor
        tabBarView.deselectedColor = self.item.theme(at: self.selectedIndex).deselectedColor
        tabBarView.indicatorViewExtendedWidth = Layout.TabBarView.indicatorViewExtendedWidthTop
        tabBarView.delegate = self
        tabBarView.backgroundColor = .clear

        return tabBarView
    }()

    // MARK: - Init
    
    init(item: Item, selectedIndex: Index = 0, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {
        precondition(selectedIndex >= 0 && selectedIndex < item.controllers.count, "Out of bounds selectedIndex")

        self.selectedIndex = selectedIndex
        self.item = item        
        
        super.init(nibName: nil, bundle: nil)

        setupButton(with: leftIcon, button: leftButton)
        setupButton(with: rightIcon, button: rightButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addContentView()
        setupHierarchy()
        setupScrollView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        didSelectItemAtIndex(index: selectedIndex, sender: tabBarView)
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

// MARK: - Private

private extension TopTabBarController {

    func button(with action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: action, for: .touchUpInside)

        return button
    }

    func setupButton(with image: UIImage?, button: UIButton) {
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = item.theme(at: selectedIndex).selectedColor
        button.isHidden = image == nil
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)        
    }

    func setupScrollView() {
        guard item.containsScrollView == false else {
            let halfContentSize = scrollView.contentSize.width * 0.5
            let offset = view.bounds.size.width - halfContentSize
            scrollViewContentOffset = halfContentSize - offset

            return
        }

        let width: CGFloat = view.bounds.width
        scrollView.frame = view.bounds
        let multiplier: CGFloat = item.enableTabScrolling == false ? CGFloat(1) : CGFloat(item.controllers.count)
        scrollView.contentSize = CGSize(width: multiplier * width, height: 0)
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

// MARK: - Actions

extension TopTabBarController {

    func leftButtonPressed(_ button: UIButton) {
        delegate?.didSelectLeftButton(sender: self)        
    }

    func rightButtonPressed(_ button: UIButton) {
        delegate?.didSelectRightButton(sender: self)
    }
}

// MARK: - UIScrollViewDelegate

extension TopTabBarController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tabBarView.setSelectedIndex(scrollView.currentPage, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard item.enableTabScrolling == false else {
            return
        }
        
        let offsetX = abs(scrollViewContentOffset * CGFloat(selectedIndex > 0 ? selectedIndex : 1))
        let alpha = scrollView.contentOffset.x / offsetX
        nextView.alpha = selectedIndex > previousIndex ? alpha : 1 - alpha
        currentView.alpha = selectedIndex > previousIndex ? 1 - alpha : alpha
        navigationItemBar.backgroundColor = item.theme(at: selectedIndex).navigationBarBackgroundColor
    }
}

extension TopTabBarController: ContentScrollViewDelegate {

    func didEndDecelerating(_ contentOffset: CGPoint) {
        tabBarView.setSelectedIndex(contentOffset.equalTo(.zero) == true ? 0 : 1, animated: true)
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
            let backgroundImageView = UIImageView(frame: view.bounds)
            backgroundImageView.image = R.image.backgroundStrategies()
            view.addSubview(backgroundImageView)
            view.addSubview(scrollView)
        }
    }
    
    func setupLayout() {
        guard item.controllers.first?.classForCoder !== LearnContentListViewController.classForCoder() else {
            navigationItemBar.heightAnchor == 0

            return
        }

        navigationItemBar.horizontalAnchors == view.horizontalAnchors
        navigationItemBar.topAnchor == view.topAnchor
        navigationItemBar.heightAnchor == 64
        
        leftButton.leftAnchor == navigationItemBar.leftAnchor
        leftButton.bottomAnchor == navigationItemBar.bottomAnchor
        leftButton.topAnchor == navigationItemBar.topAnchor + 20
        leftButton.widthAnchor == 44
        
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
        scrollView.topAnchor == navigationItemBar.bottomAnchor - 64
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

        previousIndex = selectedIndex
        selectedIndex = index

        guard index != scrollView.currentPage || item.containsScrollView == true else {
            return
        }

        if item.enableTabScrolling == false {
            currentView = item.controllers[previousIndex].view
            nextView = item.controllers[selectedIndex].view
        }

        let offset = CGPoint(x: scrollViewContentOffset * CGFloat(index), y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
}
