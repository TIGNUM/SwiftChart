//
//  SettingsCalendarListCoordinator.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsCalendarListCoordinator: ParentCoordinator {

    private let services: Services
    private let settingsCalendarListViewController: SettingsCalendarListViewController!
    private let rootViewController: UIViewController
    var children = [Coordinator]()

    init(root: OldSettingsViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        let viewModel = SettingsCalendarListViewModel(services: services)
        settingsCalendarListViewController = SettingsCalendarListViewController(viewModel: viewModel)
        let backgroundImageView = UIImageView(frame: rootViewController.view.frame)
        backgroundImageView.image = R.image.backgroundSidebar()
        settingsCalendarListViewController.setTableViewBackgound(backgroundImageView)
        settingsCalendarListViewController.title = R.string.localized.settingsGeneralCalendarTitle().uppercased()
    }

    func start() {
        rootViewController.pushToStart(childViewController: settingsCalendarListViewController)
    }
}
