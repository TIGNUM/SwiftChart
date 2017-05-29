//
//  Endpoint.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire

enum Endpoint: String {
    
    case authentication = "/service/auth"
    case contentCategories = "/service/contentCategories"

    func url(baseURL: URL) -> URL {
        return baseURL.appendingPathComponent(rawValue)
    }
}
