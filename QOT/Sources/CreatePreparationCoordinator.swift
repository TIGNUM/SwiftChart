//
//  CreatePreparationCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 03.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class CreatePreparationCoordinator: Coordinator {

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }

    func start() {
        let viewModel = PrepareEventsViewModel.mock
        let viewController = PrepareEventsViewController(viewModel: viewModel)
        rootViewController.present(viewController, animated: true)
    }
}

// MARK: - PrepareEventsViewControllerDelegate

extension CreatePreparationCoordinator: PrepareEventsViewControllerDelegate {

    func didTapClose(viewController: PrepareEventsViewController) {

    }

    func didTapAddToPrepList(viewController: PrepareEventsViewController) {

    }

    func didTapEvent(event: PrepareEventsViewModel.Event, viewController: PrepareEventsViewController) {

    }

    func didTapSavePrepToDevice(viewController: PrepareEventsViewController) {

    }
}
