//
//  PartnersCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class PartnersCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    private let services: Services
    private let selectedIndex: Index
    private let viewModel: PartnersViewModel
    private var topTabBarController: UINavigationController!
    private let partnersViewController: PartnersViewController
    private let rootViewController: UIViewController
    private let transitioningDelegate: UIViewControllerTransitioningDelegate // swiftlint:disable:this weak_delegate
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, transitioningDelegate: UIViewControllerTransitioningDelegate, selectedIndex: Index, permissionsManager: PermissionsManager) {
        self.rootViewController = root
        self.services = services
        self.transitioningDelegate = transitioningDelegate
        self.selectedIndex = selectedIndex
        viewModel = PartnersViewModel(services: services, selectedIndex: selectedIndex, headline: "Lore ipsum impsum plus")
        partnersViewController = PartnersViewController(viewModel: viewModel, permissionsManager: permissionsManager)
        partnersViewController.title = R.string.localized.meSectorMyWhyPartnersTitle()

        super.init()

        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        let rightButton = UIBarButtonItem(withImage: R.image.ic_edit())
        rightButton.tintColor = .white40
        topTabBarController = UINavigationController(withPages: [partnersViewController], topBarDelegate: self, leftButton: leftButton, rightButton: rightButton)
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.transitioningDelegate = transitioningDelegate
    }

    func start() {
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - TopTabBarDelegate

extension PartnersCoordinator: NavigationItemDelegate {
    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {
    }

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {
        partnersViewController.editCurrentItem()
    }
}
