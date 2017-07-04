//
//  PrepareContentCoordinator.swift
//  QOT
//
//  Created by karmic on 24.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import LoremIpsum

protocol PrepareContentCoordinatorDelegate: class {
    func prepareContentDidFinish(coordinator: PrepareContentCoordinator)
}

final class PrepareContentCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    var children: [Coordinator] = []
    weak var delagate: PrepareContentCoordinatorDelegate?

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, eventTracker: EventTracker) {
        self.rootViewController = root
        self.services = services
    }

    func mockPrepareContent() -> PrepareContentViewModel {
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
                                                subtitle: LoremIpsum.title(),
                                                video: video,
                                                description: LoremIpsum.words(withNumber: Int.random(between: 30, and: 100)),
                                                items: items)
        return viewModel
    }

    func start() {
        let viewModel = self.mockPrepareContent()
        let prepareContentViewController = PrepareContentViewController(viewModel: viewModel)
        prepareContentViewController.delegate = self

        rootViewController.present(prepareContentViewController, animated: true)
    }
}

// MARK: - PrepareContentViewControllerDelegate

extension PrepareContentCoordinator: PrepareContentViewControllerDelegate {
    func didTapSavePreparation(in viewController: PrepareContentViewController) {
        let coordinator = CreatePreparationCoordinator(root: viewController, services: services)
        startChild(child: coordinator)
    }

    func didTapClose(in viewController: PrepareContentViewController) {
        viewController.dismiss(animated: true, completion: nil)
        delagate?.prepareContentDidFinish(coordinator: self)
    }

    func didTapShare(in viewController: PrepareContentViewController) {
        log("didTapShare")
    }

    func didTapVideo(with videoURL: URL, from view: UIView, in viewController: PrepareContentViewController) {
        log("didTapVideo: :")
    }

    func didTapReadMore(readMoreID: Int, in viewController: PrepareContentViewController) {
        log("didTapReadMore: ID: \(readMoreID)")
    }
}

// MARK: - TopTabBarDelegate

extension PrepareContentCoordinator: TopTabBarDelegate {

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        delagate?.prepareContentDidFinish(coordinator: self)
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print(index as Any, sender)
    }
}
