//
//  TopTabBarController.swift
//  QOT
//
//  Created by tignum on 4/5/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class TopTabBarController: UIViewController {
    
    fileprivate lazy var navigationItemBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return view
    }()
    
    fileprivate lazy var tabBarView: TabBarView = {
       let view = TabBarView()
        view.backgroundColor = .white
        view.setTitles(["FULL", "BULLETS"], selectedIndex: 0)
        return view
    }()
    
    fileprivate lazy var leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
    }()
    
    fileprivate lazy var rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         setupLayout()
    }
}

extension TopTabBarController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 5
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 5
    }
}

extension TopTabBarController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}

extension TopTabBarController {
    
    func setupHierarchy() {
        view.addSubview(navigationItemBar)
        navigationItemBar.addSubview(leftButton)
        navigationItemBar.addSubview(rightButton)
        navigationItemBar.addSubview(tabBarView)
       
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
        
       view.layoutIfNeeded()
    }
}
