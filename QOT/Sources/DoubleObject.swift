//
//  DoubleObject.swift
//  QOT
//
//  Created by karmic on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class DoubleObject: Object {

    @objc private(set) dynamic var value: Double = 0

    convenience init(double: Double) {
        self.init()

        self.value = double
    }

    func delete() {
        if let realm = realm {
            realm.delete(self)
        }
    }
}
