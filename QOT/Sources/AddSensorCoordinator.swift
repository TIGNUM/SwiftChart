//
//  AddSensorCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

final class AddSensorCoordinator: ParentCoordinator {

    // MARK: - Properties

    static var safariViewController: SFSafariViewController?
    fileprivate let services: Services
    fileprivate let addSensorViewController: AddSensorViewController
    var children = [Coordinator]()
    fileprivate let rootViewController: UIViewController

    // MARK: - Init

    init(root: SidebarViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        addSensorViewController = AddSensorViewController(viewModel: AddSensorViewModel())       
        addSensorViewController.title = R.string.localized.sidebarTitleSensor().uppercased()
        addSensorViewController.delegate = self
    }

    // MARK: - Coordinator -> Starts

    func start() {
        rootViewController.pushToStart(childViewController: addSensorViewController)
    }
}

// MARK: - AddSensorViewControllerDelegate

extension AddSensorCoordinator: AddSensorViewControllerDelegate {

    func didTapSensor(_ sensor: AddSensorViewModel.Sensor, in viewController: UIViewController) {
        switch sensor {
        case .fitbit:
            guard
                let settingValue = services.settingsService.settingValue(key: "b2b.fitbit.authorizationurl"),
                case .text(let urlString) = settingValue,
                let url = URL(string: urlString) else {
                    return
            }

            do {
                let safariViewController = try SafariViewController(url)
                AddSensorCoordinator.safariViewController = safariViewController
                viewController.present(safariViewController, animated: true)
            } catch {
                log("Failed to open url. Error: \(error)")
            }
        case .requestDevice:
            viewController.present(setupAlert(), animated: true, completion: nil)
        default:
            print("sensor not yet implemented")
        }
    }
}

// MARK: - private

private extension AddSensorCoordinator {
    func setupAlert() -> UIAlertController {

        let alertController = UIAlertController(title: R.string.localized.addSensorViewAlertTitle(), message: R.string.localized.addSensorViewAlertMessage(), preferredStyle: .alert)
        let sendAction = UIAlertAction(title: R.string.localized.addSensorViewAlertSend(), style: .default) { [weak alertController] _ in
            if let alertController = alertController {
                _ = alertController.textFields![0] as UITextField
                //use data of text feild for storing!!
            }
        }
        let cancelAction = UIAlertAction(title: R.string.localized.addSensorViewAlertCancel(), style: .cancel) { _ in }
        alertController.addTextField { textField in
            textField.placeholder = R.string.localized.addSensorViewAlertPlaceholder()
        }

        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}
