//
//  SettingsCoordinator.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsCoordinator: ParentCoordinator {
    
    fileprivate let rootViewController: SettingsMenuViewController
    fileprivate let services: Services
    fileprivate let settingsType: SettingsViewModel.SettingsType
    var children = [Coordinator]()

    init(root: SettingsMenuViewController, services: Services, settingsType: SettingsViewModel.SettingsType) {
        self.rootViewController = root
        self.services = services
        self.settingsType = settingsType
    }

    func start() {
        guard let viewModel = SettingsViewModel(services: services, settingsType: settingsType) else {
            return
        }

        let settingsViewController = SettingsViewController(viewModel: viewModel)
        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [settingsViewController],
            themes: [.dark],
            titles: [settingsType.title]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,            
            leftIcon: R.image.ic_back()
        )

        topTabBarController.delegate = self
        settingsViewController.delegate = self
        rootViewController.presentRightToLeft(controller: topTabBarController)
    }
}

// MARK: - TopTabBarDelegate

extension SettingsCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismissLeftToRight()
        removeChild(child: self)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index as Any, sender)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SettingsCoordinator: SettingsViewControllerDelegate {

    func didValueChanged(at indexPath: IndexPath, enabled: Bool) {
        // Update ViewModel with changes.
    }

    func didTapPickerCell(at indexPath: IndexPath, selectedValue: String) {
        // Update view with nice animation and show/hide picker view.
    }

    func didTapButton(at indexPath: IndexPath) {
        // Navigate to selected view, like tutorial.
    }

    func updateViewModelAndReload(viewController: SettingsViewController) {
        guard let viewModel = SettingsViewModel(services: services, settingsType: settingsType) else {
            return
        }

        viewController.update(viewModel: viewModel)
    }
}
