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
    
    fileprivate var items: [Item]
    
    fileprivate let tabBarView: TabBarView
    
    weak var delegate: TabBarControllerDelegate?
    var viewControllers: [UIViewController] {
        return items.map { $0.controller }
    }
    
    init(items: [Item], selectedIndex: Index) {
        precondition(selectedIndex >= 0 && selectedIndex < items.count, "Out of bounds selectedIndex")
        
        let tabBarView = TabBarView()
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
    
    fileprivate var controllers = [UIViewController]()
    var index: Int = 0
    fileprivate lazy var navigationItemBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return view
    }()
    
    //    fileprivate lazy var tabBarView: TabBarView = {
    //        let view = TabBarView()
    //        view.backgroundColor = .white
    //        view.setTitles(["FULL", "BULLETS"], selectedIndex: 0)
    //        return view
    //    }()
    
    fileprivate lazy var leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .green
        view.isPagingEnabled = true
        view.delegate = self
        return view
    }()
    
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
    
    func buttonPressed(_ button: UIButton) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    func setupScrollView() {
        let width: CGFloat = self.view.bounds.width
        
        print(width)
        // items[0].controller.view.frame
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

let vcs: [UIViewController] = {
    let vc = UIViewController()
    vc.view.backgroundColor = .yellow
    let vc2 = UIViewController()
    vc2.view.backgroundColor = .blue
    
    return [vc, vc2]
}()

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
            if index == 0 {
                let offset = CGPoint(x: scrollView.contentOffset.x - scrollView.bounds.size.width, y: 0)
                scrollView.setContentOffset(offset, animated: true)
            }
            if index == 1 {
                let offset = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.size.width, y: 0)
                scrollView.setContentOffset(offset, animated: true)
            }
            if index == 2 {
                let offset = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.size.width, y: 0)
                scrollView.setContentOffset(offset, animated: true)
            }
            
            if index == 3 {
                let offset = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.size.width, y: 0)
                scrollView.setContentOffset(offset, animated: true)
            }
        }
    }
}

private extension UIScrollView {
    
    var currentPage: Int {
        return Int(round(self.contentOffset.x / self.bounds.size.width))
    }
}
