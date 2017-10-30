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
    fileprivate let transitioningDelegate: UIViewControllerTransitioningDelegate
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, transitioningDelegate: UIViewControllerTransitioningDelegate, services: Services, permissionHandler: PermissionHandler) {
        self.rootViewController = root
        self.transitioningDelegate = transitioningDelegate
        self.services = services
        self.viewModel = MyToBeVisionViewModel(services: services)
        myToBeVisionViewController = MyToBeVisionViewController(viewModel: self.viewModel, permissionHandler: permissionHandler)
        myToBeVisionViewController.modalPresentationStyle = .custom
        
        super.init()
        
        myToBeVisionViewController.transitioningDelegate = transitioningDelegate
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
