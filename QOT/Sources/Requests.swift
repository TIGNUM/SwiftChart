//
//  Requests.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

struct AuthenticationRequest: URLRequestBuildable {
    let endpoint: Endpoint = .authentication
    let httpMethod: HTTPMethod = .post
    let headers: [HTTPHeader: String]
    let requiresAuthentication = false

    init(username: String, password: String, location: CLLocation?) {
        var headers: [HTTPHeader: String] = [
            .Authorization: "Basic " + "\(username):\(password)".toBase64(),
            .authUser: "qot"
        ]
        if let location = location {
            let dateFormatter = DateFormatter.iso8601
            headers[.altitude] = String(location.altitude)
            headers[.latitude] = String(location.coordinate.latitude)
            headers[.longitude] = String(location.coordinate.longitude)
            headers[.verticalAccuracy] = String(location.verticalAccuracy)
            headers[.horizontalAccuracy] = String(location.horizontalAccuracy)
            headers[.createdOnDevice] = dateFormatter.string(from: location.timestamp)
            if let floor = location.floor {
                headers[.floor] = String(floor.level)
            }
        }
        self.headers = headers
    }
}

struct StartSyncRequest: URLRequestBuildable {
    let endpoint: Endpoint = .startSync
    let httpMethod: HTTPMethod = .post
    let paramaters: [RequestParameter: Any]

    init(from: Int64) {
        self.paramaters = [.from: from]
    }
}

struct DownSyncRequest: URLRequestBuildable {
    let endpoint: Endpoint
    let httpMethod: HTTPMethod = .post
    let headers: [HTTPHeader: String]
    let paramaters: [RequestParameter: Any]

    init(endpoint: Endpoint, syncToken: String, page: Int, pageSize: Int = 50) {
        self.endpoint = endpoint
        self.headers = [.syncToken: syncToken]
        self.paramaters = [.page: page, .size: pageSize]
    }
}

struct DownSyncConfirmRequest: URLRequestBuildable {
    let endpoint: Endpoint
    let httpMethod: HTTPMethod = .post
    let headers: [HTTPHeader: String]

    init(endpoint: Endpoint, syncToken: String) {
        self.endpoint = endpoint
        self.headers = [.syncToken: syncToken]
    }
}

struct UpSyncRequest: URLRequestBuildable {
    let endpoint: Endpoint
    let httpMethod: HTTPMethod = .put
    let headers: [HTTPHeader: String]
    let body: Data?

    init(endpoint: Endpoint, body: Data, syncToken: String) {
        self.endpoint = endpoint
        self.body = body
        self.headers = [.syncToken: syncToken]
    }
}

struct FitbitTokenRequest: URLRequestBuildable {
    let endpoint: Endpoint
    let httpMethod: HTTPMethod = .post
    let body: Data?

    init(endpoint: Endpoint, body: Data) {
        self.endpoint = endpoint
        self.body = body
    }
}

struct DevicePermissionsRequest: URLRequestBuildable {
    let endpoint: Endpoint = .devicePermission
    let httpMethod: HTTPMethod = .put
    let body: Data?

    init(data: Data) {
        self.body = data
    }
}

struct ResetPasswordRequest: URLRequestBuildable {
    let endpoint: Endpoint = .resetPassword
    let httpMethod: HTTPMethod = .put
    let paramaters: [RequestParameter: Any]
    let requiresAuthentication = false

    init(username: String) {
        self.paramaters = [.email: username]
    }
}

struct UserAnswerFeedbackRequest: URLRequestBuildable {
    let endpoint: Endpoint = .userAnswerFeedback
    let httpMethod: HTTPMethod = .put
    let body: Data?

    init(_ userAnswers: [UserAnswer]) {
        self.body = try? (userAnswers.flatMap { $0.toJson() }).toJSON().serialize()
    }
}

struct PartnerSharingRequest: URLRequestBuildable {
    let endpoint: Endpoint = .partnerSharing
    let httpMethod: HTTPMethod = .post
    let paramaters: [RequestParameter: Any]

    init(partnerID: Int, sharingType: Partners.SharingType) {
        self.paramaters = [
            .qotPartnerId: partnerID,
            .qotpartnersharingtype: sharingType.rawValue
        ]
    }
}

struct UserLocationUpdateRequest: URLRequestBuildable {
    let endpoint: Endpoint = .userLocationUpdate
    let httpMethod: HTTPMethod = .put
    let body: Data?

    init(_ location: CLLocation) {
        do {
            self.body = try location.toJson()?.toJSON().serialize()
        } catch {
            body = nil
            log("Error while trying to serialize user location data: \(error)", level: .error)
        }
    }
}

struct APNSDeviceTokenRequest: URLRequestBuildable {
    let endpoint: Endpoint = .pushNotificationToken
    let httpMethod: HTTPMethod = .put
    let paramaters: [RequestParameter: Any]

    init(token: String, urbanAirshipAppKey: String) {
        self.paramaters = [
            .notificationToken: token,
            .notificationEnvironmentType: Environment.name,
            .appKey: urbanAirshipAppKey
        ]
    }
}

struct DeviceRequest: URLRequestBuildable {
    let endpoint: Endpoint = .device
    let httpMethod: HTTPMethod = .put
    let body: Data?
    let headers: [HTTPHeader: String]

    init(data: Data, syncToken: String) {
        self.body = data
        self.headers = [.syncToken: syncToken]
    }
}

struct UserSearchResultRequest: URLRequestBuildable {
    let endpoint: Endpoint = .userSearchResult
    let httpMethod: HTTPMethod = .put
    var paramaters: [RequestParameter: Any]

    init(contentId: Int?, contentItemId: Int?, filter: Search.Filter, query: String) {
        self.paramaters = [.filter: filter.title.uppercased(),
                           .query: query]

        if let contentId = contentId {
            self.paramaters[.contentId] = contentId
        }

        if let contentItemId = contentItemId {
            self.paramaters[.contentItemId] = contentItemId
        }
    }
}

struct AppEventRequest: URLRequestBuildable {
    let endpoint: Endpoint = .appEvent
    let httpMethod: HTTPMethod = .put
    let paramaters: [RequestParameter: Any]

    enum EventType: String {
        case start = "APP_START"
        case background = "BACKGROUND"
        case foreground = "FOREGROUND"
        case termination = "TERMINATION"
    }

    init(eventType: EventType) {
        self.paramaters = [.eventDate: DateFormatter.iso8601.string(from: Date()),
                           .qotAppEventType: eventType.rawValue,
                           .deviceDto: [RequestParameter.id.rawValue: deviceID]]
    }
}
