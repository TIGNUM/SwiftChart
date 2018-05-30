//
//  Environment.swift
//  QOT
//
//  Created by Sam Wyndham on 05/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

#if DEBUG
var environment = Environment.development // Change here to try a different environment
#else
var environment = Environment.production
#endif

struct Environment {

    let name: String
    let initialBaseURL: URL
    var dynamicBaseURL: URL?

    var baseURL: URL {
        return dynamicBaseURL ?? initialBaseURL
    }
}

extension Environment {

    static var development = Environment(name: "DEVELOPMENT",
                                         initialBaseURL: URL(string: "https://esb.tignum.com")!, // URL(string: "https://esb-staging.tignum.com")!,
                                         dynamicBaseURL: nil)

    static var production = Environment(name: "PRODUCTION",
                                        initialBaseURL: URL(string: "https://esb.tignum.com")!,
                                        dynamicBaseURL: nil)
}
