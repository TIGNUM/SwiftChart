//
//  SettingsCoordinator.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsCoordinatorDelegate: class {

    func openCalendarListViewController(settingsViewController: SettingsViewController)

    func openChangePasswordViewController(settingsViewController: SettingsViewController)

    func openArticleViewController(viewController: SettingsViewController, settingsType: SettingsType)
}

final class SettingsCoordinator: ParentCoordinator {

    fileprivate let rootViewController: SettingsMenuViewController
    fileprivate let services: Services
    fileprivate let settingsType: SettingsType.SectionType
    fileprivate let settingsViewController: SettingsViewController
    fileprivate var topTabBarController: UINavigationController!
    var children = [Coordinator]()

    init?(root: SettingsMenuViewController, services: Services, settingsType: SettingsType.SectionType) {
        self.rootViewController = root
        self.services = services
        self.settingsType = settingsType
        
        guard let viewModel = SettingsViewModel(services: services, settingsType: settingsType) else {
            return nil
        }

        let leftButton = UIBarButtonItem(withImage: R.image.ic_back())
        settingsViewController = SettingsViewController(viewModel: viewModel, services: services, settingsType: settingsType)
        settingsViewController.title = settingsType.title
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

// MARK: - SettingsCoordinatorDelegate

extension SettingsCoordinator: SettingsCoordinatorDelegate {

    func openCalendarListViewController(settingsViewController: SettingsViewController) {
        let coordinator = SettingsCalendarListCoordinator(root: settingsViewController, services: services)
        startChild(child: coordinator)
    }

    func openChangePasswordViewController(settingsViewController: SettingsViewController) {
        let coordinator = ResetPasswordCoordinator(rootVC: settingsViewController, parentCoordinator: self, networkManager: NetworkManager())
        startChild(child: coordinator)
    }

    func openArticleViewController(viewController: SettingsViewController, settingsType: SettingsType) {
        let contentCollection = settingsType.contentCollection(service: services.contentService)
        guard let coordinator = ArticleContentItemCoordinator(
            root: viewController,
            services: services,
            contentCollection: contentCollection,
            articleHeader: nil,
            topTabBarTitle: contentCollection?.title) else {
                return
        }
        
        startChild(child: coordinator)
    }
}
