//
//  Notification+Navigation.swift
//  LevelNavigationDemo
//
//  Created by Sanggeon Park on 20.06.19.
//  Copyright © 2019 TIGNUM GmbH. All rights reserved.
//

import Foundation

extension Notification.Name {
    /* EXAMPLE:
     let navigationItem = BottomNavigationItem(leftBarButtonItems: [dismissNavigationItem()],
                                               rightBarButtonItems: [coachNavigationItem()],
                                               backgroundColor: viewController.view.backgroundColor)
     NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
     */
    static let updateBottomNavigation = Notification.Name("updateBottomNavigation")
}
