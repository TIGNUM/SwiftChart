//
//  SensorAuthorisationHandler.swift
//  QOT
//
//  Created by Moucheg Mouradian on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

final class SensorAuthorisationHandler {

    private enum SensorType: String {
        case fitbit = "fitbit-integration#"
    }

    static func process(urlString: String) {
        // Fitbit
        let urlParts = urlString.components(separatedBy: SensorType.fitbit.rawValue)
        if urlParts.count == 2 {
            guard let accessToken = getFitbitAccessToken(urlString: urlParts[1]) else { return }

            AppDelegate.current.window?.showProgressHUD(type: .fitbit, actionBlock: {
                sendAccessToken(accessToken: accessToken)
            })
        }
    }

    // MARK: - Fitbit

    private static func getFitbitAccessToken(urlString: String) -> String? {
        let parameters = urlString.components(separatedBy: "&")
        if parameters.count > 0 {
            for parameter in parameters {
                if parameter.contains("access_token=") {
                    let accessToken = parameter.components(separatedBy: "=")
                    return accessToken.count > 0 ? accessToken[1] : nil
                }
            }
        }

        return nil
    }

    private static func sendAccessToken(accessToken: String) {
        let networkManager = NetworkManager()
        let token = ["accessToken": accessToken]
        do {
            let body = try token.toJSON().serialize()

            let request = FitbitTokenRequest(endpoint: .fitbitToken, body: body)

            networkManager.request(request, parser: GenericParser.parse) { (result) in
                switch result {
                case .success:
                    AppDelegate.current.window?.showProgressHUD(type: .fitbitSuccess, actionBlock: {})
                case .failure(let error):
                    switch error.type {
                    case .unauthenticated:
                        AppDelegate.current.window?.showProgressHUD(type: .unauthenticated, actionBlock: {})
                    case .noNetworkConnection:
                        AppDelegate.current.window?.showProgressHUD(type: .noNetworkConnection, actionBlock: {})
                    case .unknown(let error, _):
                        AppDelegate.current.window?.showProgressHUD(type: .custom(title: R.string.localized.alertTitleCustom(), message: error.localizedDescription), actionBlock: {})
                    case .failedToParseData(_, let error):
                        AppDelegate.current.window?.showProgressHUD(type: .custom(title: R.string.localized.alertTitleCustom(), message: error.localizedDescription), actionBlock: {})
                    default:
                        AppDelegate.current.window?.showProgressHUD(type: .fitbitFailure, actionBlock: {})
                    }

                }
            }
        } catch {
            return
        }

    }
}
