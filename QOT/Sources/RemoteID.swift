//
//  IntObject.swift
//  QOT
//
//  Created by Sam Wyndham on 19.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class RemoteID: Object {

    private(set) dynamic var value: Int = 0

    convenience init(remoteID: Int) {
        self.init()

        self.value = remoteID
    }
}
