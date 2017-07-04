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
        viewController.delegate = self
        rootViewController.present(viewController, animated: true)
    }
}

// MARK: - PrepareEventsViewControllerDelegate

extension CreatePreparationCoordinator: PrepareEventsViewControllerDelegate {

    func didTapClose(viewController: PrepareEventsViewController) {
        viewController.dismiss(animated: true)
    }

    func didTapAddToPrepList(viewController: PrepareEventsViewController) {
        print("didTapAddToPrepList")
    }

    func didTapEvent(event: PrepareEventsViewModel.Event, viewController: PrepareEventsViewController) {
        print("didTapEvent")
    }

    func didTapSavePrepToDevice(viewController: PrepareEventsViewController) {
        print("didTapSavePrepToDevice")
    }

    func didTapAddNewTrip(viewController: PrepareEventsViewController) {
        print("didTapAddNewTrip")
    }
}
