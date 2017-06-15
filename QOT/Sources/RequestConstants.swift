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
    case contentCollection = "/personal/p/qot/content"
    case contentItems = "/personal/p/qot/contentItem"
    case user = "/personal/p/qot/userData"
    case downSyncConfirm = "/personal/p/qot/confirm"

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
    case contentType = "Content-Type"
    case syncToken = "x-tignum-sync-token"
}
