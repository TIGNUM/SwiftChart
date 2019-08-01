//
//  Notification+MySprints.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 29/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension Notification.Name {
    struct MySprintDetailsKeys {
        static let sprint = "sprint"
    }

    // MySprints data was updated and the list needs to be reloaded
    static let didUpdateMySprintsData = Notification.Name("didUpdateMySprintsData")
}
