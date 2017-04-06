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
class TopTabBarController: UIViewController {
    
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
        scrollView.frame = vcs.first!.view.frame
        scrollView.contentSize = CGSize(width: CGFloat(vcs.count) * width, height: 0)
        _ = vcs.map({ addViewToScrollView($0) })
        _ = vcs.map({ $0.view.frame.origin =  CGPoint(x: CGFloat(vcs.index(of: $0)!) * width, y: 0) })
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
        if index == 0 {
            let offset = CGPoint(x: scrollView.contentOffset.x - scrollView.bounds.size.width, y: 0)
            scrollView.setContentOffset(offset, animated: true)
        }
        if index == 1 {
            let offset = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.size.width, y: 0)
            scrollView.setContentOffset(offset, animated: true)
        }
    }
}

private extension UIScrollView {
    var currentPage: Int {
        return Int(round(self.contentOffset.x / self.bounds.size.width))
    }
}
