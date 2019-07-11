//
//  MyQotRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfileRouter {

    // MARK: - Properties

    private let viewController: MyQotProfileViewController

    // MARK: - Init

    init(viewController: MyQotProfileViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyQotRouterInterface

extension MyQotProfileRouter: MyQotProfileRouterInterface {

    func presentAccountSettings() {
        viewController.performSegue(withIdentifier: R.segue.myQotProfileViewController.myQotAccountSettingsSegueIdentifier, sender: nil)
    }

    func presentAppSettings() {
        viewController.performSegue(withIdentifier: R.segue.myQotProfileViewController.myQotAppSettingsSegueIdentifier, sender: nil)
    }

    func presentSupport() {
        viewController.performSegue(withIdentifier: R.segue.myQotProfileViewController.myQotSupportSegueIdentifier, sender: nil)
    }

    func presentAboutTignum() {
        guard let vieController = R.storyboard.myToBeVision.instantiateInitialViewController() else { return  }
        MyVisionConfigurator.configure(viewController: vieController)
        viewController.present(vieController, animated: true, completion: nil)

//        viewController.performSegue(withIdentifier: R.segue.myQotProfileViewController.myQotAboutTignumSegueIdentifier, sender: nil)
    }

    func presentMyLibrary() {
        viewController.performSegue(withIdentifier: R.segue.myQotProfileViewController.myQotMyLibrarySegueIdentifier, sender: nil)
    }
}
