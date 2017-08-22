//
//  SettingsCalendarListCoordinator.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import EventKit

final class SettingsCalendarListCoordinator: ParentCoordinator {

    fileprivate let services: Services
    fileprivate let settingsCalendarListViewController: SettingsCalendarListViewController!
    fileprivate let rootViewController: UIViewController
    var children = [Coordinator]()

    init(root: SettingsViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        let viewModel = SettingsCalendarListViewModel(services: services)
        settingsCalendarListViewController = SettingsCalendarListViewController(viewModel: viewModel)
        let backgroundImageView = UIImageView(frame: rootViewController.view.frame)
        backgroundImageView.image = R.image.backgroundSidebar()
        settingsCalendarListViewController.tableView.backgroundView = backgroundImageView
        settingsCalendarListViewController.title = R.string.localized.settingsGeneralCalendarTitle().uppercased()
    }

    func start() {
        rootViewController.pushToStart(childViewController: settingsCalendarListViewController)
    }
}
