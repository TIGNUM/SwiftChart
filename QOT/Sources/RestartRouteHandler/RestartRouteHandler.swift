//
//  RestartRouteHandler.swift
//  QOT
//
//  Created by Sanggeon Park on 16.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

class RestartHelper {

    static func setRestartURLScheme(_ scheme: URLScheme, options: [LaunchOption: String] ) {
        guard
            let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
            let urlSchemes = urlTypes[0]["CFBundleURLSchemes"] as? [String] else {
                return
        }

        let urlString = "\(urlSchemes[0])://\(scheme.rawValue)"
        if let url = URL(string: urlString),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems = options.map {
                URLQueryItem(name: $0.rawValue, value: $1)
            }
            if let URL = components.url {
                UserDefault.restartRouteURLString.setStringValue(value: URL.absoluteString)
            }
        }
    }

    func checkRestartURLAndRoute() {
        guard let restartRouteURLString = UserDefault.restartRouteURLString.stringValue,
            let restartRouteURL = URL(string: restartRouteURLString) else {
                RestartHelper.clearRestartRouteInfo()
                return
        }

        UIApplication.shared.open(restartRouteURL, options: [ : ], completionHandler: nil)
        RestartHelper.clearRestartRouteInfo()
    }

    static func clearRestartRouteInfo() {
        UserDefault.restartRouteURLString.clearObject()
    }
}
