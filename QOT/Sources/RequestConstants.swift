//
//  Constants.swift
//  QOT
//
//  Created by Sam Wyndham on 31.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Alamofire

var baseURL = URL(string: "https://esb.tignum.com")!

enum Endpoint: String {
    case authentication = "/service/auth"
    case startSync = "/personal/p/qot/start"
    case contentCategories = "/personal/p/qot/contentCategory"
    case contentCollection = "/personal/p/qot/content"
    case contentItems = "/personal/p/qot/contentItem"
    case contentRead = "/personal/p/qot/contentVisits"
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
    case devicePermission = "https://esb.tignum.com/personal/p/qot/devicePermission"
    case userAnswerFeedback = "/personal/p/qot/userAnswerFeedback"
    case userFeedback = "/personal/p/qot/userFeedback"
    case userLocationUpdate = "/personal/p/qot/geolocation"
    case log = "/personal/p/qot/log"
    case calendarSettingSync = "/personal/p/qot/calendar"
    case guideItemsLearn = "/personal/p/qot/guide/learnItem/v2"
    case guideItemsNotification = "/personal/p/qot/guide/notificationItem"
    case guide = "/personal/p/qot/guide"
    case device = "/personal/p/qot/device"
    case partnerSharing = "/personal/p/qot/qotpartnersharing"
    case appEvent = "/personal/p/qot/qotappevent"

    func url(baseURL: URL) -> URL {
        if let url = URL(string: rawValue), url.host != nil { return url }
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
    case appKey
    case qotPartnerId
    case qotpartnersharingtype
    case eventDate
    case qotAppEventType
    case deviceDto
    case id
}

enum HTTPHeader: String {
    case Authorization
    case authToken = "token"
    case contentType = "Content-Type"
    case syncToken = "x-tignum-sync-token"
    case deviceID = "X-Tignum-Device-Identifier"
    case authUser = "authUser" // X-Tignum-Auth-User
    case versionPlain = "version"
    case versionX = "X-Tignum-Qot-Version"
    case build = "X-Tignum-Qot-Build"
    case os = "X-Tignum-Qot-Os"
    case altitude = "X-Tignum-Qot-Altitude"
    case latitude = "X-Tignum-Qot-Latitude"
    case longitude = "X-Tignum-Qot-Longitude"
    case verticalAccuracy = "X-Tignum-Qot-VerticalAccuracy"
    case horizontalAccuracy = "X-Tignum-Qot-HorizontalAccuracy"
    case floor = "X-Tignum-Qot-Floor"
    case createdOnDevice = "X-Tignum-Qot-CreatedOnDevice"
}
