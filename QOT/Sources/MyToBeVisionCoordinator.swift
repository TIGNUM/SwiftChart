//
//  MyToBeVisionCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyToBeVisionCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    fileprivate let services: Services
    fileprivate var myToBeVisionViewController: MyToBeVisionViewController!
    private let viewModel: MyToBeVisionViewModel
    fileprivate let rootViewController: UIViewController
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, permissionHandler: PermissionHandler) {
        self.rootViewController = root
        self.services = services
        self.viewModel = MyToBeVisionViewModel(services: services)
        myToBeVisionViewController = MyToBeVisionViewController(viewModel: self.viewModel, permissionHandler: permissionHandler)
        myToBeVisionViewController.modalPresentationStyle = .custom
        
        super.init()
        
        myToBeVisionViewController.transitioningDelegate = self
        myToBeVisionViewController.delegate = self
    }

    func start() {
        rootViewController.present(myToBeVisionViewController, animated: true)
    }
}

// MARK: - MyToBeVisionViewControllerDelegate

extension MyToBeVisionCoordinator: MyToBeVisionViewControllerDelegate {

    func didTapClose(in viewController: MyToBeVisionViewController) {
        viewController.dismiss(animated: true, completion: {
            self.removeChild(child: self)
        })
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MyToBeVisionCoordinator: UIViewControllerTransitioningDelegate {
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
