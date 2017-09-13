//
//  Constants.swift
//  QOT
//
//  Created by Sam Wyndham on 31.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Alamofire

let baseURL = URL(string: "https://esb.tignum.com")!

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
    case userSetting = "/personal/p/qot/userSetting"
    case fitbitToken = "/b2b/fitbit/token"
    case resetPassword = "/service/personal/p/resetpassword"
    case emailCheck = "/personal/p/user/by-email"
    case dataPoint = "/personal/p/qot/dataPoint"
    case userChoice = "/personal/p/qot/userChoice"
    case partner = "/personal/p/qot/qotPartner"
    case myToBeVision = "/personal/p/qot/toBeVision"
    case media = "/personal/p/qot/media"
    case userPreparation = "/personal/p/qot/userPreparation"
    case userPreparationCheck = "/personal/p/qot/userPreparationContentItem"
    case userAnswer = "/personal/p/qot/userAnswer"
    case pageTracking = "/personal/p/qot/pageTracking"
    case pushNotificationToken = "/personal/p/qot/deviceToken"
    
    func url(baseURL: URL) -> URL {
        return baseURL.appendingPathComponent(rawValue)
    }
}

enum RequestParameter: String {
    case from
    case size
    case page
    case email
    case notificationEnvironmentType
    case notificationToken
}

enum HTTPHeader: String {
    case Authorization
    case authToken = "token"
    case contentType = "Content-Type"
    case syncToken = "x-tignum-sync-token"
    case deviceID = "X-Tignum-Device-Identifier"
    case authUser = "authUser"
    case version = "version"
}
