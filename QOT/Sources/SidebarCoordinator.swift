//
//  SidebarCoordinator.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SidebarCoordinator: ParentCoordinator {

    private let services: Services
    private var topTabBarController: UINavigationController!
    private let sideBarViewController: SidebarViewController!
    private let rootViewController: UIViewController
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    var children = [Coordinator]()

    init(root: UIViewController, services: Services, syncManager: SyncManager, networkManager: NetworkManager) {
        self.rootViewController = root
        self.services = services
        self.networkManager = networkManager
        self.syncManager = syncManager        
        let viewModel = SidebarViewModel(services: services)
        sideBarViewController = SidebarViewController(viewModel: viewModel)
        topTabBarController = UINavigationController(withPages: [sideBarViewController],
                                                     topBarDelegate: self,
                                                     backgroundImage: R.image.sidebar(),
                                                     leftButton: UIBarButtonItem(withImage: R.image.ic_logo()),
                                                     rightButton: UIBarButtonItem(withImage: R.image.ic_close()))
        topTabBarController.modalTransitionStyle = .crossDissolve
        sideBarViewController.delegate = self
    }
    
    func start() {
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - SidebarViewControllerDelegate

extension SidebarCoordinator: SidebarViewControllerDelegate {

    func didTapLogoutCell(in viewController: SidebarViewController) {
        NotificationHandler.postNotification(withName: .logoutNotification)
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapAddSensorCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController) {
        let coordinator = AddSensorCoordinator(root: viewController, services: services)
        startChild(child: coordinator)
    }

    func didTapSettingsMenuCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController) {
        guard let coordinator = SettingsMenuCoordinator(root: viewController,
                                                        services: services,
                                                        syncManager: syncManager,
                                                        networkManager: networkManager) else {
                                                            log("could not init \(SettingsMenuCoordinator.self)")
                                                            return
        }
        startChild(child: coordinator)
    }

    func didTapLibraryCell(in viewController: SidebarViewController) {
        let coordinator = LibraryCoordinator(root: viewController, services: services)
        startChild(child: coordinator)
    }

    func didTapBenefitsCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(pageName: .benefits, contentCollection: contentCollection, viewController: viewController)
    }

    func didTapAboutCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(pageName: .about, contentCollection: contentCollection, viewController: viewController)
    }

    func didTapPrivacyCell(with contentCollection: ContentCollection?, backgroundImage: UIImage?, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(pageName: .privacy, contentCollection: contentCollection, viewController: viewController, backgroundImage: backgroundImage)
    }

    private func startSidebarItemCoordinator(pageName: PageName, contentCollection: ContentCollection?, viewController: SidebarViewController, topTabBarTitle: String? = nil, backgroundImage: UIImage? = nil) {
        guard let coordinator = ArticleContentItemCoordinator(
            pageName: pageName,
            root: viewController,
            services: services,
            contentCollection: contentCollection,
            topTabBarTitle: topTabBarTitle?.uppercased(), backgroundImage: backgroundImage) else {
                return
        }
        
        startChild(child: coordinator)
    }
}

// MARK: - TopNavigationBarDelegate

extension SidebarCoordinator: TopNavigationBarDelegate {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }
}
