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

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    fileprivate let selectedIndex: Index
    fileprivate let viewModel: PartnersViewModel
    fileprivate var partnersViewController: PartnersViewController!

    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, selectedIndex: Index) {
        self.rootViewController = root
        self.services = services
        self.selectedIndex = selectedIndex
        self.viewModel = PartnersViewModel(services: services, selectedIndex: selectedIndex, headline: "Lore ipsum impsum plus")
        
        super.init()
    }

    func start() {
        partnersViewController = PartnersViewController(viewModel: viewModel)
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
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.transitioningDelegate = self
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

// MARK: - UIViewControllerTransitioningDelegate

extension PartnersCoordinator: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresenting: true, duration: 0.4)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresenting: false, duration: 0.4)
    }
}
