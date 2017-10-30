//
//  PartnersCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class PartnersCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    fileprivate let services: Services
    fileprivate let selectedIndex: Index
    fileprivate let viewModel: PartnersViewModel
    fileprivate var topTabBarController: UINavigationController!
    fileprivate let partnersViewController: PartnersViewController
    fileprivate let rootViewController: UIViewController
    fileprivate let transitioningDelegate: UIViewControllerTransitioningDelegate
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, transitioningDelegate: UIViewControllerTransitioningDelegate, selectedIndex: Index, permissionHandler: PermissionHandler) {
        self.rootViewController = root
        self.services = services
        self.transitioningDelegate = transitioningDelegate
        self.selectedIndex = selectedIndex
        viewModel = PartnersViewModel(services: services, selectedIndex: selectedIndex, headline: "Lore ipsum impsum plus")
        partnersViewController = PartnersViewController(viewModel: viewModel, permissionHandler: permissionHandler)
        partnersViewController.title = R.string.localized.meSectorMyWhyPartnersTitle()
        
        super.init()
        
        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        let rightButton = UIBarButtonItem(withImage: R.image.ic_edit())
        rightButton.tintColor = .white40
        topTabBarController = UINavigationController(withPages: [partnersViewController], topBarDelegate: self, leftButton: leftButton, rightButton: rightButton)
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.transitioningDelegate = transitioningDelegate
    }

    func start() {
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - TopTabBarDelegate

extension PartnersCoordinator: TopNavigationBarDelegate {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        partnersViewController.editCurrentItem()
    }
}
