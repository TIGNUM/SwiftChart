//
//  UpSyncData.swift
//  QOT
//
//  Created by Sam Wyndham on 28.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

struct UpSyncData {

    let body: Data
    let completion: (LocalIDToRemoteIDMap, Realm) throws -> Void

    init(body: Data, completion: @escaping (LocalIDToRemoteIDMap, Realm) throws -> Void) {
        self.body = body
        self.completion = completion
    }
}
