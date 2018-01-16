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

    init(username: String, password: String) {
        headers = [
            .Authorization: "Basic " + "\(username):\(password)".toBase64(),
            .authUser: "qot"
        ]
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

struct GuideUpdateRequest: URLRequestBuildable {
    let endpoint: Endpoint = .guide
    let httpMethod: HTTPMethod = .put
    let body: Data?

    init(_ guide: RealmGuide) {
        self.body = nil
    }
}

struct GuideNotificationUpdateRequest: URLRequestBuildable {
    let endpoint: Endpoint = .guideNotification
    let httpMethod: HTTPMethod = .put
    let body: Data?

    init(_ guide: RealmGuide) {
        self.body = nil
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
    let body: Data
    let headers: [HTTPHeader: String]

    init(data: Data, syncToken: String) {
        self.body = data
        self.headers = [.syncToken: syncToken]
    }
}
