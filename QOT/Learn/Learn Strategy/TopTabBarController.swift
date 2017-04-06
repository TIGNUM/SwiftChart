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
    func didSelectItemAtIndex(index: Int?, sender: TabBarView)
    
}
class TopTabBarController: UIViewController {
    weak var dataSource: UIPageViewControllerDataSource?
    
    fileprivate var controllers = [UIViewController]()
    var index: Int = 0
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
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setUpControllers()
        index = tabBarView.selectedIndex!
//        displayContentController(controllers[index])
//        dataSource = self
        }
    
    func buttonPressed(_ button: UIButton) {
        print("hi")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    let pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    func setUpControllers() {
         let learnStrategyViewController = LearnStrategyViewController(viewModel: LearnStrategyViewModel())
         controllers.append(learnStrategyViewController)
        let chatController = ChatViewController(viewModel: ChatViewModel())
        controllers.append(chatController)
//        let options = dictionaryWithValues(forKeys: [UIPageViewControllerOptionSpineLocationKey])
    
        pageViewController.setViewControllers([vcs[1]], direction: .forward, animated: false, completion: nil)
        pageViewController.dataSource = self
        
        displayContentController(pageViewController)
        
        tabBarView.delegate = self
    }
    
    fileprivate func displayContentController(_ viewController: UIViewController) {
       
        addChildViewController(viewController)
        viewController.view.frame = containerView.frame
        containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    let vcs: [UIViewController] = {
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .blue
        
        return [vc, vc2]
    }()
    
}


extension TopTabBarController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == vcs[0] {
            return nil
        } else if viewController == vcs[1] {
            return vcs[0]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == vcs[0] {
            return vcs[1]
        } else if viewController == vcs[1] {
            return nil
        }
        return nil
    }
}

extension TopTabBarController {
    
    func setupHierarchy() {
        view.addSubview(navigationItemBar)
        navigationItemBar.addSubview(leftButton)
        navigationItemBar.addSubview(rightButton)
        navigationItemBar.addSubview(tabBarView)
        view.addSubview(containerView)
        
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
        
        containerView.horizontalAnchors == view.horizontalAnchors
        containerView.topAnchor == navigationItemBar.bottomAnchor
        containerView.bottomAnchor == view.bottomAnchor
        
        view.layoutIfNeeded()
    }
}

extension TopTabBarController: TabBarViewDelegate {
    func didSelectItemAtIndex(index: Int?, sender: TabBarView) {
        guard let index = index else {
            return
        }
        self.index = index
        pageViewController.setViewControllers([vcs[index]], direction: .forward, animated: true, completion: nil)
}
}
