//
//  URL+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 06.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension URL {

    static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    var groupID: Int? {
        return queryStringParameter(param: "groupID").flatMap { Int($0) }
    }
}
