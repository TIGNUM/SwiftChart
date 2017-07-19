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

    let rootViewController: UIViewController
    fileprivate let services: Services
    var children = [Coordinator]()
    lazy var presentationManager = PresentationManager()
    
    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }
    
    func start() {
        let viewModel = SidebarViewModel(contentService: services.contentService)
        let sideBarViewController = SidebarViewController(viewModel: viewModel)

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [sideBarViewController],
            themes: [.darkClear]
        )
        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_logo(),
            rightIcon: R.image.ic_close()
        )

        topTabBarController.modalTransitionStyle = .crossDissolve
        topTabBarController.modalPresentationStyle = .overFullScreen
        topTabBarController.delegate = self
        sideBarViewController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - SettingsViewControllerDelegate

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
        let coordinator = SettingsMenuCoordinator(root: viewController, services: services)
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

    func didTapPrivacyCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(contentCollection: contentCollection, viewController: viewController, topTabBarTitle: R.string.localized.sidebarTitlePrivacy())
    }

    private func startSidebarItemCoordinator(contentCollection: ContentCollection?, viewController: SidebarViewController, topTabBarTitle: String) {
        guard let collection = contentCollection else {
            return
        }

        let coordinator = ArticleContentItemCoordinator(
            root: viewController,
            services: services,
            contentCollection: collection,
            articleHeader: nil,
            topTabBarTitle: topTabBarTitle.uppercased()
        )

        startChild(child: coordinator)
    }
}

// MARK: - TopTabBarDelegate

extension SidebarCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index as Any, sender)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        print("didSelectLeftButton", sender)
    }
}
