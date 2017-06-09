//
//  Requests.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire

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
