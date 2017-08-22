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
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, selectedIndex: Index) {
        self.rootViewController = root
        self.services = services
        self.selectedIndex = selectedIndex
        viewModel = PartnersViewModel(services: services, selectedIndex: selectedIndex, headline: "Lore ipsum impsum plus")
        partnersViewController = PartnersViewController(viewModel: viewModel)
        partnersViewController.title = R.string.localized.meSectorMyWhyPartnersTitle()
        
        super.init()
        
        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        let rightButton = UIBarButtonItem(withImage: R.image.ic_edit())
        topTabBarController = UINavigationController(withPages: [partnersViewController], topBarDelegate: self, leftButton: leftButton, rightButton: rightButton)
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.transitioningDelegate = self
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

// MARK: - UIViewControllerTransitioningDelegate

extension PartnersCoordinator: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresenting: true, duration: 0.4)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresenting: false, duration: 0.4)
    }
}
