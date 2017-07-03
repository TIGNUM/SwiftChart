//
//  PrepareCheckListCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 03.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import LoremIpsum

protocol PrepareCheckListCoordinatorDelegate: class {
    func prepareCheckListDidFinish(coordinator: PrepareCheckListCoordinator)
}

final class PrepareCheckListCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    var children: [Coordinator] = []
    weak var delagate: PrepareCheckListCoordinatorDelegate?

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }

    func start() {
        //        let viewModel = mockPrepareContent()
        let viewModel = mockCheckboxPrepareContent()

        let prepareContentViewController = PrepareContentViewController(viewModel: viewModel)

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [prepareContentViewController],
            themes: [.light],
            titles: [R.string.localized.topTabBarItemTitlePerpareCoach()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize(),
            rightIcon: R.image.ic_save()
        )

        prepareContentViewController.delegate = self
        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }

    private func mockCheckboxPrepareContent() -> PrepareContentViewModel {
        // TODO: Mock data, should be removed
        let video = PrepareContentViewModel.Video(url: URL(string: "https://www.youtube.com/watch?v=ScMzIvxBSi4")!, placeholderURL: URL(string: "http://missionemanuel.org/wp-content/uploads/2015/02/photo-video-start-icon1.png?w=640"))

        var items: [PrepareItem] = []

        for _ in 0...Int.random(between: 5, and: 10) {
            let newItem = PrepareItem(id: Int.randomID,
                                      title: LoremIpsum.title(),
                                      subTitle: LoremIpsum.words(withNumber: Int.random(between: 30, and: 100)),
                                      readMoreID: Int.randomID)

            items.append(newItem)
        }

        let viewModel = PrepareContentViewModel(title: LoremIpsum.title(),
                                                video: video,
                                                description: LoremIpsum.words(withNumber: Int.random(between: 30, and: 100)),
                                                items: items,
                                                checkedIDs: [:])
        
        return viewModel
    }
}

// MARK: - PrepareContentViewControllerDelegate

extension PrepareCheckListCoordinator: PrepareContentViewControllerDelegate {

    func didTapClose(in viewController: PrepareContentViewController) {
        viewController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didTapShare(in viewController: PrepareContentViewController) {
        log("didTapShare")
    }

    func didTapSavePreparation(in viewController: PrepareContentViewController) {

    }

    func didTapVideo(with videoURL: URL, from view: UIView, in viewController: PrepareContentViewController) {
        log("didTapVideo: :")
    }

    func didTapReadMore(readMoreID: Int, in viewController: PrepareContentViewController) {
        log("didTapReadMore: ID: \(readMoreID)")
        //        startPrepareEventsCoordinator(viewController: viewController)
    }
}

// MARK: - TopTabBarDelegate

extension PrepareCheckListCoordinator: TopTabBarDelegate {

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        delagate?.prepareCheckListDidFinish(coordinator: self)
    }
    
    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print(index as Any, sender)
    }
}
