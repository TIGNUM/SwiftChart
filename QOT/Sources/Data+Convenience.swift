//
//  Data+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 19.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Data {
    var utf8String: String? {
        return String(data: self, encoding: .utf8)
    }
}
