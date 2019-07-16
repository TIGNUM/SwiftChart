//
//  Notification+MyLibrary.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension Notification.Name {
    // MyLibrary data was updated and the list needs to be reloaded
    static let didUpdateMyLibraryData = Notification.Name("didUpdateMyLibraryData")
}
