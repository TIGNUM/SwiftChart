//
//  URL+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 06.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension URL {

    static var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static var libraryDirectory: URL {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
    }

    static var imageDirectory: URL {
        return libraryDirectory.appendingPathComponent("image")
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

    func isLocalImageDirectory() -> Bool {
        let localPathComponents = self.baseURL?.pathComponents ?? []
        let expectedPathComponents = URL.imageDirectory.pathComponents
        return localPathComponents.elementsEqual(expectedPathComponents)
    }
}
