//
//  URL+Components.swift
//  QOT
//
//  Created by karmic on 19.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension URL {

    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else {
            return nil
        }

        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
