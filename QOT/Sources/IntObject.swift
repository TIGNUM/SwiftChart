//
//  IntObject.swift
//  QOT
//
//  Created by Sam Wyndham on 20.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class IntObject: Object {

    @objc private(set) dynamic var value: Int = 0

    convenience init(int: Int) {
        self.init()

        self.value = int
    }
}
