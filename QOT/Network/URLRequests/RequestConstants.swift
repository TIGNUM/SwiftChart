//
//  Constants.swift
//  QOT
//
//  Created by Sam Wyndham on 31.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Alamofire

enum Endpoint: String {

    case authentication = "/service/auth"
    case startSync = "/personal/p/qot/start"
    case contentCategories = "/personal/p/qot/contentCategory"

    func url(baseURL: URL) -> URL {
        return baseURL.appendingPathComponent(rawValue)
    }
}

enum RequestParameter: String {
    case from
    case size
    case page
}

enum HTTPHeader: String {
    case Authorization
    case authToken = "token"
    case conentType = "Content-Type"
    case syncToken = "x-tignum-sync-token"
}
