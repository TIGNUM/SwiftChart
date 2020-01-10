//
//  MyQotAdminSettingsListRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminSettingsListRouter {

    // MARK: - Properties
    private weak var viewController: MyQotAdminSettingsListViewController?

    // MARK: - Init
    init(viewController: MyQotAdminSettingsListViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAdminSettingsListRouterInterface
extension MyQotAdminSettingsListRouter: MyQotAdminSettingsListRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func presentEnvironmentSettings() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAdminSettingsListViewController.myQotAdminEnvironmentSettingsSegueIdentifier, sender: nil)
    }

    func presentLocalNotificationsSettings() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAdminSettingsListViewController.myQotAdminLocalNotificationsSegueIdentifier, sender: nil)
    }

    func presentSixthQuestionPriority() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAdminSettingsListViewController.myQotAdminDCSixthQuestionSegueIdentifier, sender: nil)
    }

    func presentChooseDailyBriefBuckets() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAdminSettingsListViewController.myQotAdminChooseBucketsSegueIdentifier, sender: nil)
    }

    func presentEditSprints() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAdminSettingsListViewController.myQotAdminEditSprintsSegueIdentifier, sender: nil)
    }
}
