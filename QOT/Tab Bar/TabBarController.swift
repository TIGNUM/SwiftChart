//
//  TabBarController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
final class TabBarController: UIViewController {
    
    // MARK: - Properties
    struct TabBarItems {
        let controller : UIViewController
        let title: String
    }
    
    fileprivate var categoryViewControllers = [UIViewController]()
    fileprivate let selectedCategoryIndex: Index
    
    fileprivate lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .red
        return view
    }()
    
    private func createButton(title: String) {
        let button = UIButton()
        button.titleLabel?.text = title
        stackView.addSubview(button)
    }
    
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
        view.addSubview(stackView)
        // delegate = self
        setupView()
    }
    private func loadTabs() {
        
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
        
        //            tabBar.barTintColor = .black
        //            tabBar.tintColor = .qotWhite
        //            viewControllers = categoryViewControllers
        //           selectedIndex = selectedCategoryIndex
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        log("didSelect viewController: \(viewController)")
    }
}

extension TabBarController {
    func setUpLayouts() {
        stackView.bottomAnchor == view.bottomAnchor
        stackView.leftAnchor == view.leftAnchor
        stackView.rightAnchor == view.rightAnchor
        stackView.heightAnchor == 64
    }
}
