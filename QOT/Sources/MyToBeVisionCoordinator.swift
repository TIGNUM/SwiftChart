//
//  MyToBeVisionCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyToBeVisionCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    private let services: Services
    private let rootViewController: UIViewController
    private let transitioningDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate
    private let options: [LaunchOption: String?]
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController,
         transitioningDelegate: UIViewControllerTransitioningDelegate?,
         services: Services,
         options: [LaunchOption: String?]? = nil) {
        self.rootViewController = root
        self.transitioningDelegate = transitioningDelegate
        self.services = services
        self.options = options ?? [:]
        super.init()
    }

    func start() {
        let configurator = MyToBeVisionConfigurator.make(options)
        let myToBeVisionViewController = MyToBeVisionViewController(configurator: configurator)
        let currentToBeVision = services.userService.myToBeVision()
        if let toBeVision = currentToBeVision, toBeVision.headline != nil, toBeVision.text != nil {
            let navController = UINavigationController(rootViewController: myToBeVisionViewController)
            navController.navigationBar.applyDefaultStyle()
            navController.modalPresentationStyle = .custom
            navController.transitioningDelegate = transitioningDelegate
            rootViewController.present(navController, animated: true)
        } else {
            let visionModel = MyToBeVisionModel.Model(headLine: currentToBeVision?.headline,
                                                      imageURL: currentToBeVision?.profileImageResource?.url,
                                                      lastUpdated: currentToBeVision?.date,
                                                      text: currentToBeVision?.text,
                                                      needsToRemind: currentToBeVision?.needsToRemind,
                                                      workTags: currentToBeVision?.keywords(for: .work),
                                                      homeTags: currentToBeVision?.keywords(for: .home))
            let chatItems = services.questionsService.visionChatItems
            let chatViewController = VisionGeneratorConfigurator.visionGeneratorViewController(toBeVision: visionModel,
                                                                                               visionController: myToBeVisionViewController,
                                                                                               visionChatItems: chatItems)
            let navController = UINavigationController(rootViewController: chatViewController)
            navController.navigationBar.applyDefaultStyle()
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .custom
            chatViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.ic_close(),
                                                                                  landscapeImagePhone: nil,
                                                                                  style: .plain,
                                                                                  target: chatViewController,
                                                                                  action: #selector(chatViewController.dismiss(_:)))
            chatViewController.navigationItem.leftBarButtonItem?.tintColor = .white40

            rootViewController.present(navController, animated: true)
        }
    }
}
