//
//  DownSyncChange.swift
//  QOT
//
//  Created by Sam Wyndham on 23.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum DownSyncChange<T> {
    case createdOrUpdated(remoteID: Int, createdAt: Date, modifiedAt: Date, data: T)
    case deleted(remoteID: Int)
}
