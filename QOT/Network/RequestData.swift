//
//  RequestData.swift
//  QOT
//
//  Created by Sam Wyndham on 22.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire

struct RequestData {
    var headers = HTTPHeaders()
    var parameters = Parameters()
    var endpoint: Endpoint
    var httpMethod: HTTPMethod
}
