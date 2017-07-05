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
    fileprivate let selectedIndex: Index
    fileprivate let viewModel: PartnersViewModel

    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, eventTracker: EventTracker, selectedIndex: Index) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
        self.selectedIndex = selectedIndex
        
        let items: [PartnerIntermediary] = services.partnerService.partners().map({ (partner: Partner) -> PartnerIntermediary in
            return PartnerIntermediary(
                localID: partner.localID,
                profileImage: partner.profileImage,
                profileImageURL: partner.profileImageURL,
                name: partner.name ?? "",
                surname: partner.surname ?? "",
                initials: partner.initials,
                relationship: partner.relationship ?? "",
                email: partner.email ?? "")
        })
        self.viewModel = PartnersViewModel(items: items, selectedIndex: selectedIndex, headline: "Lore ipsum impsum plus")
    }

    func start() {
        let partnersViewController = PartnersViewController(viewModel: viewModel)

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [partnersViewController],
            themes: [.dark],
            titles: [R.string.localized.meSectorMyWhyPartnersTitle()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize(),
            rightIcon: R.image.ic_edit()
        )

        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
    
    func save() {
        services.partnerService.update(viewModel.items.flatMap({$0}), completion: nil)
    }
}

// MARK: - TopTabBarDelegate

extension PartnersCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print(index as Any, sender)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        save()
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        guard let partnersController = sender.item.controllers.first as? PartnersViewController else {
            return
        }

        partnersController.editCurrentItem()
    }
}
