//
//  LaunchHandler.swift
//  QOT
//
//  Created by Moucheg Mouradian on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

struct LaunchHandler {

    static let `default` = LaunchHandler()

    enum URLScheme: String {
        case fitbit = "fitbit-integration"
        case preparation = "preparation"
        case dailyPrep = "morning-interview"
        case weeklyChoices = "weekly-choices"
        case randomContent = "random-content"
        case weeklyPeakPerformance = "weekly-peak-performance"

        static var allValues: [URLScheme] {
            return [
                .fitbit,
                .preparation,
                .dailyPrep,
                .weeklyChoices,
                .randomContent,
                .weeklyPeakPerformance
            ]
        }

        var queryName: String {
            switch self {
            case .fitbit: return "code"
            case .preparation: return "#"
            case .dailyPrep: return "groupID"
            case .weeklyChoices: return ""
            case .randomContent: return "key"
            case .weeklyPeakPerformance: return ""
            }
        }

        func queryParametter(url: URL) -> String? {
            return url.queryStringParameter(param: queryName)
        }
    }

    func process(url: URL) {
        guard
            let host = url.host,
            let scheme = URLScheme(rawValue: host) else {
                return
        }

        switch scheme {
        case .dailyPrep: dailyPrep(groupID: scheme.queryParametter(url: url))
        case .fitbit: fitbit(accessToken: scheme.queryParametter(url: url))
        case .preparation: preparation(localID: url.absoluteString.components(separatedBy: scheme.queryName).last)
        case .randomContent: randomContent(contentID: scheme.queryParametter(url: url))
        case .weeklyChoices: weeklyChoiches()
        case .weeklyPeakPerformance: return
        }
    }

    func generatePreparationURL(withID localID: String) -> String? {
        guard
            let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
            let urlSchemes = urlTypes[0]["CFBundleURLSchemes"] as? [String] else {
                return nil
        }

        return "\(urlSchemes[0])://\(URLScheme.preparation.rawValue)\(URLScheme.preparation.queryName)\(localID)"
    }
}

// MARK: - Preparation

extension LaunchHandler {

    func preparation(localID: String?) {
        guard let localID = localID else {
            return
        }

        AppDelegate.current.appCoordinator.presentPreparationCheckList(localID: localID)
    }
}

// MARK: - Fitbit

extension LaunchHandler {

    func fitbit(accessToken: String?) {
        AddSensorCoordinator.safariViewController?.dismiss(animated: true, completion: nil)
        AppDelegate.current.window?.showProgressHUD(type: .fitbit) {
            self.sendAccessToken(accessToken: accessToken)
        }
    }

    private func sendAccessToken(accessToken: String?) {
        guard let accessToken = accessToken else {
            showHUD(type: .fitbitFailure)

            return
        }

        do {
            let body = try ["accessToken": accessToken].toJSON().serialize()
            let request = FitbitTokenRequest(endpoint: .fitbitToken, body: body)

            NetworkManager().request(request, parser: GenericParser.parse) { (result: (Result<(), NetworkError>)) in
                switch result {
                case .success: self.showHUD(type: .fitbitSuccess)
                case .failure(let error): self.handleFitbitFailure(error)
                }
            }
        } catch let error {
            showHUD(type: .custom(title: R.string.localized.alertTitleCustom(), message: error.localizedDescription))

            return
        }
    }

    private func handleFitbitFailure(_ error: NetworkError) {
        switch error.type {
        case .unauthenticated: showHUD(type: .unauthenticated)
        case .noNetworkConnection: showHUD(type: .noNetworkConnection)
        case .unknown(let error, _),
             .failedToParseData(_, let error): showHUD(type: .custom(title: R.string.localized.alertTitleCustom(), message: error.localizedDescription))
        case .cancelled: showHUD(type: .fitbitFailure)
        }
    }

    private func showHUD(type: AlertType) {
        AppDelegate.current.window?.showProgressHUD(type: type)
    }
}

// MARK: - Daily Prep

extension LaunchHandler {

    func dailyPrep(groupID: String?) {
        guard
            let groupID = groupID,
            let groupIDIntValue = Int(groupID) else {
                return
        }

        AppDelegate.current.appCoordinator.presentMorningInterview(groupID: groupIDIntValue)
    }
}

// MARK: - Weekly Choices

extension LaunchHandler {

    func weeklyChoiches() {
        let dates = startEndDate()
        AppDelegate.current.appCoordinator.presentWeeklyChoices(forStartDate: dates.startDate, endDate: dates.endDate)
    }

    private func startEndDate() -> (startDate: Date, endDate: Date) {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .weekOfYear, .weekday], from: Date())
        dateComponents.weekOfYear! += 1
        dateComponents.weekday! = 1
        let startDate = calendar.date(from: dateComponents)!
        dateComponents.weekOfYear! += 1
        let endDate = calendar.date(from: dateComponents)!

        return (startDate: startDate, endDate: endDate)
    }
}

// MARK: - Random Content

extension LaunchHandler {

    func randomContent(contentID: String?) {
        guard
            let contentIDString = contentID,
            let contentID = Int(contentIDString) else {
                return
        }

        AppDelegate.current.appCoordinator.presentArticleView(contentID: contentID)
    }
}
