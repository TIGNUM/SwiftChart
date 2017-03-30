//
//  TabBarController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol TabBarControllerDelegate: class {
    func didSelect(viewController: UIViewController)
}

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    fileprivate var categoryViewControllers = [UIViewController]()
    fileprivate let selectedCategoryIndex: Index
    weak var tabBarDelegate: TabBarControllerDelegate?
    
    // MARK: - Life Cycle
    
    init(viewControllers: [UIViewController], selectedIndex: Index) {
        self.categoryViewControllers = viewControllers
        self.selectedCategoryIndex = selectedIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setupView()
    }
    
    private func setupView() {
        let learnTabBarItem = UITabBarItem(title: R.string.localized.tabBarItemLearn(), image: nil, selectedImage: nil)
        let meTabBarItem = UITabBarItem(title: R.string.localized.tabBarItemMe(), image: nil, selectedImage: nil)
        let prepareTabBarItem = UITabBarItem(title: R.string.localized.tabBarItemPrepare(), image: nil, selectedImage: nil)
        
        let learnCategoryController = categoryViewControllers.item(at: MainMenuType.learn.rawValue) as? LearnCategoryListViewController
        learnCategoryController?.tabBarItem = learnTabBarItem
        
        let meCategoryController = categoryViewControllers.item(at: MainMenuType.me.rawValue) as? MeSectionViewController
        meCategoryController?.tabBarItem = meTabBarItem
        
        let chatViewController = categoryViewControllers.item(at: MainMenuType.prepare.rawValue) as? ChatViewController
        chatViewController?.tabBarItem = prepareTabBarItem
        
        tabBar.barTintColor = .black
        tabBar.tintColor = Color.Default.white
        viewControllers = categoryViewControllers
        selectedIndex = selectedCategoryIndex
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        log("didSelect viewController: \(viewController)")
        tabBarDelegate?.didSelect(viewController: viewController)
    }
}
