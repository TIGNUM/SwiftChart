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

    private let services: Services
    private let rootViewController: UIViewController
    private var webViewController: WebViewController?
    private let notificationHandler: NotificationHandler
   
    var children = [Coordinator]()
    let addSensorViewController: AddSensorViewController

    // MARK: - Init

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        addSensorViewController = AddSensorViewController(viewModel: AddSensorViewModel(userService: services.userService))
        addSensorViewController.title = R.string.localized.sidebarTitleSensor().uppercased()
        notificationHandler = NotificationHandler(center: .default, name: .fitbitAccessTokenReceivedNotification)
        notificationHandler.handler = { [unowned self] notification in
            self.webViewController?.dismiss(animated: true, completion: nil)
        }
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
            if services.userService.fitbitState == .connected || services.userService.fitbitState == .pending,
                let url = URL(string: "https://www.fitbit.com/user/profile/apps") {
                    presentSafariViewController(url: url, viewController: viewController)
            } else {
                presentFitBitWebView(in: viewController)
            }
        case .requestDevice:
            viewController.present(setupAlert(), animated: true, completion: nil)
        default:
            log("sensor not yet implemented")
        }
    }
}

// MARK: - private

private extension AddSensorCoordinator {
    
    func presentFitBitWebView(in viewController: UIViewController) {
        guard
            let settingValue = services.settingsService.settingValue(key: "b2b.fitbit.authorizationurl"),
            case .text(let urlString) = settingValue,
            let url = URL(string: urlString) else {
                return
        }
        presentSafariViewController(url: url, viewController: viewController)
    }
    
    func presentSafariViewController(url: URL, viewController: UIViewController) {
        do {
            let webViewController = try WebViewController(url)
            self.webViewController = webViewController
            viewController.present(webViewController, animated: true)
            NotificationCenter.default.addObserver(self, selector: #selector(reloadAddSensorViewController), name: .syncAllDidFinishNotification, object: nil)
        } catch {
            log("Failed to open url. Error: \(error)")
            viewController.showAlert(type: .message(error.localizedDescription))
        }
    }
    
    @objc func reloadAddSensorViewController() {
        addSensorViewController.reloadCollectionView()
        NotificationCenter.default.removeObserver(self, name: .syncAllDidFinishNotification, object: nil)
    }
    
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
