//
//  MyQotMainRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotMainRouter {

    // MARK: - Properties

    private let viewController: MyQotMainViewController
    private let services: Services
    weak var delegate: CoachCollectionViewControllerDelegate?

    // MARK: - Init

    init(viewController: MyQotMainViewController, services: Services, delegate: CoachCollectionViewControllerDelegate) {
        self.viewController = viewController
        self.services = services
        self.delegate = delegate
    }
}

// MARK: - MyQotMainRouterInterface

extension MyQotMainRouter: MyQotMainRouterInterface {

    func presentMyPreps() {
        let storyboardID = R.storyboard.myPreps.myPrepsViewControllerID.identifier
        let myPrepsViewController = R.storyboard
            .myPreps().instantiateViewController(withIdentifier: storyboardID) as? MyPrepsViewController
        if let myPrepsViewController = myPrepsViewController {
            MyPrepsConfigurator.configure(viewController: myPrepsViewController, delegate: delegate)
            viewController.pushToStart(childViewController: myPrepsViewController)
        }
    }

    func presentMyProfile() {
        let storyboardID = R.storyboard.myQot.myQotProfileID.identifier
        let myQotProfileViewController = R.storyboard
            .myQot().instantiateViewController(withIdentifier: storyboardID) as? MyQotProfileViewController
        if let myQotProfileViewController = myQotProfileViewController {
            MyQotProfileConfigurator.configure(delegate: delegate, viewController: myQotProfileViewController)
            viewController.pushToStart(childViewController: myQotProfileViewController)
        }
    }

    func presentMyToBeVision() {
        let storyboardID = R.storyboard.myToBeVision.myVisionViewController.identifier
        let myVisionViewController = R.storyboard
            .myToBeVision().instantiateViewController(withIdentifier: storyboardID) as? MyVisionViewController
        if let myVisionViewController = myVisionViewController {
            MyVisionConfigurator.configure(viewController: myVisionViewController)
            viewController.pushToStart(childViewController: myVisionViewController)
        }
    }
}
