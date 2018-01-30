//
//  URL+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 06.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension URL {

    static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    var groupID: Int? {
        return queryStringParameter(param: "groupID").flatMap { Int($0) }
    }

    func queryStringParameter(param: String) -> String? {
        guard let url = URLComponents(string: absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }

    func queryItems() -> [URLQueryItem] {
        guard
            let url = URLComponents(string: absoluteString),
            let queryItems = url.queryItems else { return [] }
        return queryItems
    }
}
