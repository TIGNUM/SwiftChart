//
//  WeeklyChoicesCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class WeeklyChoicesCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    private let rootViewController: UIViewController
    private let services: Services
    private let weeklyChoicesViewController: WeeklyChoicesViewController
    private let transitioningDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate
    private let launchHandler = LaunchHandler()
    private let rightButton: UIBarButtonItem = UIBarButtonItem(withImage: R.image.prepareContentPlusIcon())
    private let provider: WeeklyChoicesProvider
    var children: [Coordinator] = []
    var topTabBarController: UINavigationController!

    // MARK: - Life Cycle

    init(root: UIViewController,
         services: Services,
         provider: WeeklyChoicesProvider,
         transitioningDelegate: UIViewControllerTransitioningDelegate?,
         topBarDelegate: TopNavigationBarDelegate?) {
        self.rootViewController = root
        self.services = services
        self.transitioningDelegate = transitioningDelegate
        self.provider = provider
        
        let viewData = provider.provideViewData()
        weeklyChoicesViewController = WeeklyChoicesViewController(viewData: viewData)
        weeklyChoicesViewController.title = R.string.localized.meSectorMyWhyWeeklyChoicesTitle()

        super.init()

        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        topTabBarController = UINavigationController(withPages: [weeklyChoicesViewController],
                                                     topBarDelegate: topBarDelegate ?? self,
                                                     leftButton: leftButton,
                                                     rightButton: (viewData.pages.count == 0) ? rightButton : nil)
        topTabBarController.modalPresentationStyle = .custom
        if transitioningDelegate != nil {
            topTabBarController.transitioningDelegate = transitioningDelegate
        }
        weeklyChoicesViewController.delegate = self
        
        provider.updateBlock = { [unowned self] viewData in
            self.weeklyChoicesViewController.viewData = viewData
        }
    }

    func start() {
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - WeeklyChoicesViewControllerDelegate

extension WeeklyChoicesCoordinator: WeeklyChoicesViewControllerDelegate {

    func weeklyChoicesViewController(_ viewController: WeeklyChoicesViewController, didTapClose: Bool, animated: Bool) {
        viewController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }
    
    func weeklyChoicesViewController(_ viewController: WeeklyChoicesViewController, didUpdateListWithViewData viewData: WeeklyChoicesViewData) {
        topTabBarController.navigationBar.topItem?.rightBarButtonItem = (viewData.pages.count == 0) ? rightButton : nil
    }
}

// MARK: - TopNavigationBarDelegate

extension WeeklyChoicesCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        weeklyChoicesViewController.dismiss(animated: true, completion: nil)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        launchHandler.weeklyChoiches { [unowned self] in
            self.weeklyChoicesViewController.viewData = self.provider.provideViewData()
        }
    }
}
