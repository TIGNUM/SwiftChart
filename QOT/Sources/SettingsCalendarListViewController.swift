//
//  SettingsCalendarListViewController.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import EventKit

protocol SettingsCalendarListViewControllerDelegate: class {
    func didChangeCalendarSyncValue(sender: UISwitch, calendarIdentifier: String)
}
