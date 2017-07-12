//
//  Constants.swift
//  QOT
//
//  Created by Sam Wyndham on 31.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Alamofire

let baseURL = URL(string: "https://esb2.tignum.com")!

enum Endpoint: String {

    case authentication = "/service/auth"
    case startSync = "/personal/p/qot/start"
    case contentCategories = "/personal/p/qot/contentCategory"
    case contentCollection = "/personal/p/qot/content"
    case contentItems = "/personal/p/qot/contentItem"
    case user = "/personal/p/qot/userData"
    case downSyncConfirm = "/personal/p/qot/confirm"
    case page = "/personal/p/qot/qotPage"
    case calendarEvent = "/personal/p/qot/calendarEvent"
    case question = "/personal/p/qot/question"
    case systemSetting = "/personal/p/qot/systemSetting"
    case userSetting = "/personal/p/qot/userSetting2"
    case fitbitToken = "/b2b/fitbit/token"
    case userChoice = "/personal/p/qot/userChoice"

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
    case deviceID = "X-Tignum-Device-Identifier"
}
