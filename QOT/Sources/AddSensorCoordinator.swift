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
    var children = [Coordinator]()
    lazy var presentationManager = PresentationManager()

    // MARK: - Init

    init(root: SidebarViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }

    // MARK: - Coordinator -> Starts

    func start() {
        let addSensorVC = AddSensorViewController(viewModel: AddSensorViewModel())
        presentationManager.presentationType = .fadeIn
        addSensorVC.modalPresentationStyle = .custom
        addSensorVC.transitioningDelegate = presentationManager

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [addSensorVC],
            themes: [.dark],
            titles: [R.string.localized.sidebarTitleSensor()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize()
        )

        addSensorVC.delegate = self
        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - AddSensorViewControllerDelegate

extension AddSensorCoordinator: AddSensorViewControllerDelegate {

    func didTapSensor(_ sensor: AddSensorViewModel.Sensor, in viewController: UIViewController) {
        print("Did tap sensor \(sensor)")
        switch sensor {
        case .fitbit:
            guard let url = URL(string: "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=228JJ5&redirect_uri=qotapp%3A%2F%2Ffitbit-integration&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&expires_in=604800") else { return }

            AddSensorCoordinator.safariViewController = SFSafariViewController(url: url)
            guard let webViewController = AddSensorCoordinator.safariViewController else { return }
            viewController.present(webViewController, animated: true)
        case .requestDevice:
                viewController.present(setupAlert(), animated: true, completion: nil)

        default:
            print("sensor not yet implemented")
        }
    }
}

// MARK: - TopTabBarDelegate

extension AddSensorCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex")
    }
}

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
