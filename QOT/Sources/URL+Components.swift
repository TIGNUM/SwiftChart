//
//  URL+Components.swift
//  QOT
//
//  Created by karmic on 19.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension URL {

    func queryStringParameter(param: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else {
            return nil
        }

        return url.queryItems?.first(where: { $0.name == param })?.value
    }

    func queryItems() -> [URLQueryItem] {
        guard
            let url = URLComponents(string: self.absoluteString),
            let queryItems = url.queryItems else {
                return []
        }

        return queryItems
    }
}
