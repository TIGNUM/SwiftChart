//
//  PartnersCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class PartnersCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let partners: [Partner]
    fileprivate let selectedIndex: Index

    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, eventTracker: EventTracker, partners: [Partner], selectedIndex: Index) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
        self.partners = partners
        self.selectedIndex = selectedIndex
    }

    func start() {
        let partnersViewController = PartnersViewController(viewModel: PartnersViewModel(items: partners, selectedIndex: selectedIndex))
        partnersViewController.delegate = self
        let partnersItem = TopTabBarController.Item(controller: partnersViewController, title: R.string.localized.meSectorMyWhyPartnersTitle())
        let topTabBarController = TopTabBarController(items: [partnersItem], selectedIndex: 0, leftIcon: R.image.ic_minimize(), rightIcon: R.image.ic_edit())
        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - WeeklyChoicesViewControllerDelegate

extension PartnersCoordinator: PartnersViewControllerDelegate {

    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapEdit(partner: Partner, in viewController: UIViewController) {
        print("didTapEDit, partmers, \(partner) ")
    }
}

// MARK: - TopTabBarDelegate

extension PartnersCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print(index, sender)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("did select edit mode:", sender)
    }
}
