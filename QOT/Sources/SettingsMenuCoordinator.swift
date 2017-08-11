//
//  SettingsMenuCoordinator.swift
//  QOT
//
//  Created by karmic on 24.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsMenuCoordinator: ParentCoordinator {

    fileprivate let rootViewController: SidebarViewController
    fileprivate let services: Services
    fileprivate var presentationManager: PresentationManager
    fileprivate var topTabBarController: UINavigationController!
    fileprivate let settingsMenuViewController: SettingsMenuViewController
    
    var children = [Coordinator]()

    init?(root: SidebarViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        
        presentationManager = PresentationManager(type: .fadeIn)
        
        guard let viewModel = SettingsMenuViewModel(services: services) else {
            return nil
        }

        let leftButton = UIBarButtonItem(withImage: R.image.ic_back())
        settingsMenuViewController = SettingsMenuViewController(viewModel: viewModel)
        presentationManager.presentationType = .fadeIn
        settingsMenuViewController.modalPresentationStyle = .custom
        settingsMenuViewController.transitioningDelegate = presentationManager
        settingsMenuViewController.title = R.string.localized.settingsTitle()
        topTabBarController = UINavigationController(withPages: [settingsMenuViewController], topBarDelegate: self, leftButton: leftButton)
        settingsMenuViewController.delegate = self
    }

    func start() {
        rootViewController.presentRightToLeft(controller: topTabBarController)
    }
}

// MARK: - SettingsMenuViewControllerDelegate

extension SettingsMenuCoordinator: SettingsMenuViewControllerDelegate {

    func didTapGeneral(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .general, root: viewController)
    }

    func didTapSecurity(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .security, root: viewController)
    }

    func didTapNotifications(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .notifications, root: viewController)
    }

    private func startSettingsCoordinator(settingsType: SettingsType.SectionType, root: SettingsMenuViewController) {
        guard let coordinator = SettingsCoordinator(root: root, services: services, settingsType: settingsType) else {
            return
        }

        startChild(child: coordinator)
    }
}

// MARK: - TopNavigationBarDelegate

extension SettingsMenuCoordinator: TopNavigationBarDelegate {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismissLeftToRight()
        removeChild(child: self)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {        
    }
}
