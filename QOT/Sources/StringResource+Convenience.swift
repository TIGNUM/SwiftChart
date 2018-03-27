//
//  StringResource+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 26/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Rswift

extension StringResource {

    var localized: String {
        return NSLocalizedString(key, tableName: tableName, comment: "")
    }
}
