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

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    fileprivate let presentationManager: PresentationManager
    fileprivate var topTabBarController: UINavigationController!
    fileprivate let sideBarViewController: SidebarViewController
    var children = [Coordinator]()

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        presentationManager = PresentationManager(type: .fadeIn)
        
        let viewModel = SidebarViewModel(services: services)
        sideBarViewController = SidebarViewController(viewModel: viewModel)
        
        let leftButton = UIBarButtonItem(withImage: R.image.ic_logo())
        let rightButton = UIBarButtonItem(withImage: R.image.ic_close())
        topTabBarController = UINavigationController(withPages: [sideBarViewController], topBarDelegate: self, backgroundImage: R.image.sidebar(), leftButton: leftButton, rightButton: rightButton)
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
        guard let coordinator = SettingsMenuCoordinator(root: viewController, services: services) else {
            print("could not init \(SettingsMenuCoordinator.self)")
            return
        }
        startChild(child: coordinator)
    }

    func didTapLibraryCell(in viewController: SidebarViewController) {
        let coordinator = LibraryCoordinator(root: viewController, services: services)
        startChild(child: coordinator)
    }

    func didTapBenefitsCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(contentCollection: contentCollection, viewController: viewController, topTabBarTitle: R.string.localized.sidebarTitleBenefits())
    }

    func didTapAboutCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(contentCollection: contentCollection, viewController: viewController, topTabBarTitle: R.string.localized.sidebarTitleAbout())
    }

    func didTapPrivacyCell(with contentCollection: ContentCollection?, backgroundImage: UIImage?, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(contentCollection: contentCollection, viewController: viewController, topTabBarTitle: R.string.localized.sidebarTitlePrivacy(), backgroundImage: backgroundImage)
    }

    private func startSidebarItemCoordinator(contentCollection: ContentCollection?, viewController: SidebarViewController, topTabBarTitle: String, backgroundImage: UIImage? = nil) {
        guard let coordinator = ArticleContentItemCoordinator(
            root: viewController,
            services: services,
            contentCollection: contentCollection,
            articleHeader: nil,
            topTabBarTitle: topTabBarTitle.uppercased(), backgroundImage: backgroundImage) else {
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
