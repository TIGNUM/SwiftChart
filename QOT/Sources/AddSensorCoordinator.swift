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
    fileprivate let rootViewController: SidebarViewController
    fileprivate let services: Services
    fileprivate let presentationManager: PresentationManager
    fileprivate var topTabBarController: UINavigationController!
    fileprivate let addSensorViewController: AddSensorViewController
    var children = [Coordinator]()

    // MARK: - Init

    init(root: SidebarViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        
        presentationManager = PresentationManager(type: .fadeIn)
        
        addSensorViewController = AddSensorViewController(viewModel: AddSensorViewModel())
        addSensorViewController.modalPresentationStyle = .custom
        addSensorViewController.transitioningDelegate = presentationManager
        addSensorViewController.title = R.string.localized.sidebarTitleSensor()

        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        topTabBarController = UINavigationController(withPages: [addSensorViewController], topBarDelegate: self, leftButton: leftButton)
        
        addSensorViewController.delegate = self
    }

    // MARK: - Coordinator -> Starts

    func start() {
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - AddSensorViewControllerDelegate

extension AddSensorCoordinator: AddSensorViewControllerDelegate {

    func didTapSensor(_ sensor: AddSensorViewModel.Sensor, in viewController: UIViewController) {
        print("Did tap sensor \(sensor)")
        switch sensor {
        case .fitbit:
            guard
                let urlString = services.settingsService.settingValue(key: "b2b.fitbit.authorizationurl")?.stringValue,
                let url = URL(string: urlString) else {
                    return
            }
            AddSensorCoordinator.safariViewController = SFSafariViewController(url: url)
            guard let webViewController = AddSensorCoordinator.safariViewController else {
                return
            }
            viewController.present(webViewController, animated: true)
        case .requestDevice:
            viewController.present(setupAlert(), animated: true, completion: nil)
        default:
            print("sensor not yet implemented")
        }
    }
}

// MARK: - TopNavigationBarDelegate

extension AddSensorCoordinator: TopNavigationBarDelegate {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
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
