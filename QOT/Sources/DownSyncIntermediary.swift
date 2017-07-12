//
//  DownSyncIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 12.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

protocol DownSyncIntermediary: JSONDecodable {

    static var remoteIDKey: JsonKey { get }
}

extension DownSyncIntermediary {

    static var remoteIDKey: JsonKey {
        return .id
    }
}
