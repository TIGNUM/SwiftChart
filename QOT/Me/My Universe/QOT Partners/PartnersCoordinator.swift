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

    fileprivate let rootViewController: MyUniverseViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let partners: [Partner]
    fileprivate let selectedIndex: Index
    fileprivate let viewModel: PartnersViewModel

    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: MyUniverseViewController, services: Services, eventTracker: EventTracker, partners: [Partner], selectedIndex: Index) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
        self.partners = partners
        self.selectedIndex = selectedIndex
        self.viewModel = PartnersViewModel(items: partners, selectedIndex: selectedIndex)
    }

    func start() {
        let partnersViewController = PartnersViewController(viewModel: viewModel)
        partnersViewController.delegate = self
        rootViewController.present(partnersViewController, animated: true)
    }
}

// MARK: - WeeklyChoicesViewControllerDelegate

extension PartnersCoordinator: PartnersViewControllerDelegate {

    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapChangeImage(at index: Index, in viewController: UIViewController) {
        print("didTapCahngeImage")
    }
}
