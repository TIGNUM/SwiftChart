//
//  MyToBeVisionCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyToBeVisionCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    private let viewModel: MyToBeVisionViewModel
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        viewModel = MyToBeVisionViewModel(services: services)
    }

    func start() {
        let myToBeVisionViewController = MyToBeVisionViewController(viewModel: viewModel)
        myToBeVisionViewController.delegate = self
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
