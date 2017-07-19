//
//  CustomAppLaunchHandler.swift
//  QOT
//
//  Created by Moucheg Mouradian on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

final class CustomAppLaunchHandler {

    enum CustomType: String {
        case fitbit = "fitbit-integration#"
        case preparation = "preparation#"
    }

    static func process(urlString: String) {
        // Fitbit
        let types: [CustomType] = [.fitbit, .preparation]

        for type in types {
            let urlParts = urlString.components(separatedBy: type.rawValue)
            if urlParts.count == 1 {
                switch type {
                case .fitbit:
                    let fitURLString = urlParts[0]
                    let fitbitToken = URL(string: fitURLString)?.getQueryStringParameter(url: fitURLString, param: "code")
                    fitbit(accessToken: fitbitToken ?? "")
                default: return
                }

                return
            } else if urlParts.count == 2 {
                switch type {
                case .fitbit:
                    fitbit(accessToken: urlParts[1])
                case .preparation:
                    preparation(localID: urlParts[1])
                }

                return
            }
        }
    }

    static func generatePreparationURL(withID localID: String) -> String? {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] else { return nil }
        guard let urlSchemes = urlTypes[0]["CFBundleURLSchemes"] as? [String] else { return nil }
        let urlScheme = urlSchemes[0]

        return "\(urlScheme)://\(CustomType.preparation.rawValue)\(localID)"
    }
}

// MARK: - Preparation

private extension CustomAppLaunchHandler {

    static func preparation(localID: String) {
        print("Preparation localID: \(localID)")

        AppDelegate.current.appCoordinator.presentPreparationCheckList(localID: localID)
    }
}

// MARK: - Fitbit

private extension CustomAppLaunchHandler {

    static func fitbit(accessToken: String) {
        AddSensorCoordinator.safariViewController?.dismiss(animated: true, completion: nil)

        AppDelegate.current.window?.showProgressHUD(type: .fitbit) {
            sendAccessToken(accessToken: accessToken)
        }
    }

    static func sendAccessToken(accessToken: String) {
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
