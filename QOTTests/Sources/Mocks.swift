//
//  Mocks.swift
//  QOT
//
//  Created by Moucheg Mouradian on 06/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
@testable import QOT

struct Mocks {
    
    static var mockedToken = "someRandomToken"
    
    private static var mocks = [
        "\(Endpoint.authentication.rawValue)": "\(Mocks.mockedToken)",
        "\(Endpoint.startSync.rawValue)": "{\"status\": \"success\"}"
    ]
    
    static func find(_ request: URLRequest ) -> Data? {
        guard var key = request.url?.pathComponents.joined(separator: "/") else { return nil }
        
        key.remove(at: key.startIndex)
        
        guard let value = mocks[key] else { return nil }
        
        return value.data(using: String.Encoding.utf8)
    }
}
