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
    fileprivate let eventTracker: EventTracker
    var children = [Coordinator]()
    lazy var presentationManager = PresentationManager()

    init(root: SidebarViewController, services: Services, eventTracker: EventTracker) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
    }

    func start() {
        let settingsMenuViewController = SettingsMenuViewController(viewModel: SettingsMenuViewModel())
        settingsMenuViewController.delegate = self
        presentationManager.presentationType = .fadeIn
        settingsMenuViewController.modalPresentationStyle = .custom
        settingsMenuViewController.transitioningDelegate = presentationManager

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [settingsMenuViewController],
            titles: [R.string.localized.settingsTitle()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,            
            leftIcon: R.image.ic_minimize()
        )

        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

extension SettingsMenuCoordinator: SettingsMenuViewControllerDelegate {

    func didTapGeneral(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .general, root: viewController)
    }

    func didTapSecurity(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .notifications, root: viewController)
    }

    func didTapNotifications(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .security, root: viewController)
    }

    private func startSettingsCoordinator(settingsType: SettingsViewModel.SettingsType, root: SettingsMenuViewController) {
        let coordinator = SettingsCoordinator(root: root, services: services, eventTracker: eventTracker, settingsType: settingsType)
        startChild(child: coordinator)
    }
}

// MARK: - TopTabBarDelegate

extension SettingsMenuCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index as Any, sender)
    }
}
