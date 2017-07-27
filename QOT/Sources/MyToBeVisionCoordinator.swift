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

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    fileprivate var myToBeVisionViewController: MyToBeVisionViewController!
    private let viewModel: MyToBeVisionViewModel
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        viewModel = MyToBeVisionViewModel(services: services)
        super.init()
    }

    func start() {
        myToBeVisionViewController = MyToBeVisionViewController(viewModel: viewModel)
        myToBeVisionViewController.delegate = self
        myToBeVisionViewController.modalPresentationStyle = .custom
        myToBeVisionViewController.transitioningDelegate = self
        rootViewController.present(myToBeVisionViewController, animated: true)
    }
    
    func save() {
        viewModel.updateDate(Date())
        services.userService.updateMyToBeVision(viewModel.item, completion: nil)
    }
}

// MARK: - MyToBeVisionViewControllerDelegate

extension MyToBeVisionCoordinator: MyToBeVisionViewControllerDelegate {

    func didTapClose(in viewController: MyToBeVisionViewController) {
        save()
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
