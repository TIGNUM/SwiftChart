//
//  SensorAuthorisationHandler.swift
//  QOT
//
//  Created by Moucheg Mouradian on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SensorAuthorisationHandler {

    private enum SensorType: String {
        case fitbit = "fitbit-integration#"
    }

    static func process(urlString: String, appCoordinator: AppCoordinator) {
        // Fitbit
        let urlParts = urlString.components(separatedBy: SensorType.fitbit.rawValue)
        if urlParts.count == 2 {
            guard let accessToken = getFitbitAccessToken(urlString: urlParts[1]) else { return }
            sendAccessToken(accessToken: accessToken, appCoordinator: appCoordinator)
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

    private static func sendAccessToken(accessToken: String, appCoordinator: AppCoordinator) {
        let networkManager = NetworkManager()
        let token = ["accessToken": accessToken]
        do {
            let body = try token.toJSON().serialize()

            let request = FitbitTokenRequest(endpoint: .fitbitToken, body: body)
            networkManager.request(request, parser: GenericParser.parse) { [weak appCoordinator] (result) in
                switch result {
                case .success:
                    print("FITBIT TOKEN UPLOAD #SUCCESS")
                case .failure(let error):
                    print("FITBIT TOKEN UPLOAD #ERROR: \(error)")
                    switch error.type {
                    case .unauthenticated:
                        appCoordinator?.showAlert(type: .unauthenticated)
                    case .noNetworkConnection:
                        appCoordinator?.showAlert(type: .noNetworkConnection)
                    case .unknown(let error, _):
                        appCoordinator?.showAlert(type: .custom(title: R.string.localized.alertTitleCustom(), message: error.localizedDescription))
                    case .failedToParseData(_, let error):
                        appCoordinator?.showAlert(type: .custom(title: R.string.localized.alertTitleCustom(), message: error.localizedDescription))
                    default:
                        break
                    }

                }
            }
        } catch {
            return
        }

    }
}
