//
//  MyQotSyncedCalendarsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotSyncedCalendarsViewControllerInterface: class {
    func setupView(with title: String)
}

protocol MyQotSyncedCalendarsPresenterInterface {
    func setupView(with title: String)
}

protocol MyQotSyncedCalendarsInteractorInterface: Interactor {
    var viewModel: SettingsCalendarListViewModel { get }
}
