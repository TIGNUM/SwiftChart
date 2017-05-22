//
//  DownSyncNetworkItem.swift
//  QOT
//
//  Created by Sam Wyndham on 22.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

enum DownSyncNetworkItem<T: JSONDecodable> {
    case createdOrUpdated(remoteID: Int, createdAt: Date, modifiedAt: Date, data: T)
    case deleted(remoteID: Int)
}
