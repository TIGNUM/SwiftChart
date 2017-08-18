//
//  Requests.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire

struct AuthenticationRequest: URLRequestBuildable {
    let endpoint: Endpoint = .authentication
    let httpMethod: HTTPMethod = .post
    let headers: [HTTPHeader: String]
    
    let username: String
    let password: String
    let deviceID: String
    
    init(username: String, password: String, deviceID: String) {
        self.username = username
        self.password = password
        self.deviceID = deviceID
        headers = [
            .Authorization: "Basic " + "\(username):\(password)".toBase64(),
            .deviceID: deviceID,
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

struct ResetPasswordRequest: URLRequestBuildable {
    let endpoint: Endpoint
    let httpMethod: HTTPMethod = .put
    let body: Data?

    init(endpoint: Endpoint, body: Data) {
        self.endpoint = endpoint
        self.body = body
    }
}

struct EmailCheckRequest: URLRequestBuildable {
    let endpoint: Endpoint
    let httpMethod: HTTPMethod = .get
    let email: String?

    init(endpoint: Endpoint, email: String?) {
        self.endpoint = endpoint
        self.email = email
    }
}
