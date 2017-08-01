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
    fileprivate let settingsViewController: SettingsViewController
    fileprivate var topTabBarController: UINavigationController!
    var children = [Coordinator]()

    init?(root: SettingsMenuViewController, services: Services, settingsType: SettingsViewModel.SettingsType) {
        self.rootViewController = root
        self.services = services
        self.settingsType = settingsType
        
        guard let viewModel = SettingsViewModel(services: services, settingsType: settingsType) else {
            return nil
        }
        
        settingsViewController = SettingsViewController(viewModel: viewModel)
        settingsViewController.title = settingsType.title
        
        let leftButton = UIBarButtonItem(withImage: R.image.ic_back())
        topTabBarController = UINavigationController(withPages: [settingsViewController], topBarDelegate: self, leftButton: leftButton)

        settingsViewController.delegate = self
    }

    func start() {
        rootViewController.presentRightToLeft(controller: topTabBarController)
    }
}

// MARK: - TopNavigationBarDelegate

extension SettingsCoordinator: TopNavigationBarDelegate {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismissLeftToRight()
        removeChild(child: self)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
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

    func didTapButton(at indexPath: IndexPath, settingsType: SettingsType) {
        // Navigate to selected view, like tutorial.

        switch settingsType {
        case .tutorial:
            Tutorials.resetTutorial()
            AppDelegate.current.window?.showProgressHUD(type: .tutorialReset, actionBlock: {})
        default: break
        }
    }

    func updateViewModelAndReload(viewController: SettingsViewController) {
        guard let viewModel = SettingsViewModel(services: services, settingsType: settingsType) else {
            return
        }

        viewController.update(viewModel: viewModel)
    }
}
