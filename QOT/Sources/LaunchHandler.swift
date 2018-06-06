//
//  LaunchHandler.swift
//  QOT
//
//  Created by Moucheg Mouradian on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD
import os.log

final class LaunchHandler {

    private var appDelegate: AppDelegate {
        return AppDelegate.current
    }

    func canLaunch(url: URL) -> Bool {
        return URLScheme.isSupportedURL(url)
    }

    func process(url: URL,
                 notificationID: String = "",
                 guideItem: Guide.Item? = nil,
                 searchViewController: SearchViewController? = nil) {
        guard let host = url.host, let scheme = URLScheme(rawValue: host) else { return }

        switch scheme {
        case .dailyPrep: dailyPrep(groupID: scheme.queryParametter(url: url), notificationID: notificationID, guideItem: guideItem)
        case .fitbit: fitbit(accessToken: scheme.queryParametter(url: url))
        case .preparation: preparation(localID: url.absoluteString.components(separatedBy: scheme.queryName).last)
        case .randomContent: randomContent(url: url, scheme: scheme, guideItem: guideItem)
        case .weeklyChoices: weeklyChoiches()
        case .meChoices: weeklyChoiches()
        case .weeklyChoicesReminder: weeklyChoicesReminder()
        case .myPreps: navigate(to: scheme.destination)
        case .toBeVision: toBeVision()
        case .weeklyPeakPerformance: navigate(to: scheme.destination)
        case .contentCategory: contentCategory(collectionID: scheme.queryParametter(url: url))
        case .featureExplainer: featureExplainer(url: url, scheme: scheme, guideItem: guideItem)
        case .strategies: navigate(to: scheme.destination)
        case .meUniverse: navigate(to: scheme.destination)
        case .preferencesSyncCalendar: navigatToSideBar(with: scheme.destination)
        case .preferencesNotification: navigatToSideBar(with: scheme.destination)
        case .addSensor: _ = appDelegate.appCoordinator.presentAddSensor()
        case .fitbitAuthrefresh: appDelegate.appCoordinator.presentAddSensor()
        case .meMyWhy: navigate(to: scheme.destination) // TODO the middleButtons are different here.
        case .meActivity: navigateToMeCharts(sector: .activity)
        case .meIntensity: navigateToMeCharts(sector: .intensity)
        case .meMeeting: navigateToMeCharts(sector: .meetings)
        case .meSleep: navigateToMeCharts(sector: .sleep)
        case .mePeakPerformance: navigateToMeCharts(sector: .peakPerformance)
        case .meTravel: navigateToMeCharts(sector: .travel)
        case .meQotPartner: return
        case .prepare: navigate(to: scheme.destination)
        case .prepareProblem: navigateToPrepare(scheme.destination)
        case .prepareEvent: navigateToPrepare(scheme.destination)
        case .prepareDay: navigateToPrepare(scheme.destination)
        case .library: appDelegate.appCoordinator.presentLibrary()
        case .guide: navigate(to: scheme.destination)
        case .latestWhatsHotArticle: navigate(to: scheme.destination)
        case .contentItem: contentItem(url: url, scheme: scheme, searchViewController: searchViewController)
        }
    }

    func navigatToSideBar(with destination: AppCoordinator.Router.Destination?) {
        guard let destination = destination else { return }
        appDelegate.appCoordinator.presentSideBarWithDestination(destination)
    }

    func navigate(to destination: AppCoordinator.Router.Destination?) {
        guard let destination = destination else { return }
        appDelegate.appCoordinator.navigate(to: destination)
    }

    func navigateToMeCharts(sector: StatisticsSectionType) {
        appDelegate.appCoordinator.presentMeCharts(sector: sector)
    }

    func navigateToPrepare(_ destination: AppCoordinator.Router.Destination?) {
        guard let destination = destination else { return }
        appDelegate.appCoordinator.presentPrepare(destination)
    }

    func syncUserDependentData(completionHandler: (() -> Void)?) {
        appDelegate.appCoordinator.syncManager.syncUserDependentData(syncContext: nil) { (error) in
            if error != nil { os_log("BackgroundFetch : Sync User Dependent Data is finished with error") }
            completionHandler?()
        }
    }
}

// MARK: - Preparation

extension LaunchHandler {

    func preparation(localID: String?) {
        guard let localID = localID else { return }
        appDelegate.appCoordinator.presentPreparationCheckList(localID: localID)
    }
}

// MARK: - Fitbit

extension LaunchHandler {

    func fitbit(accessToken: String?) {
        NotificationCenter.default.post(name: .fitbitAccessTokenReceivedNotification, object: nil)
        sendAccessToken(accessToken: accessToken)
    }

    private func sendAccessToken(accessToken: String?) {
        guard let window = appDelegate.window, let accessToken = accessToken else {
            showTemporaryHUD(type: .fitbitFailure)
            return
        }

        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        do {
            let body = try ["accessToken": accessToken].toJSON().serialize()
            let request = FitbitTokenRequest(endpoint: .fitbitToken, body: body)

            let networkManager = appDelegate.appCoordinator.networkManager
            networkManager.request(request, parser: GenericParser.parse) { (result: (Result<(), NetworkError>)) in
                hud.hide(animated: true)
                switch result {
                case .success:
                    self.showTemporaryHUD(type: .fitbitSuccess)
                    self.appDelegate.appCoordinator.syncManager.syncUserDependentData()
                case .failure(let error):
                    self.handleFitbitFailure(error)
                }
            }
        } catch let error {
            hud.hide(animated: true)
            self.showTemporaryHUD(type: .custom(title: R.string.localized.alertTitleCustom(), message: error.localizedDescription))
        }
    }

    private func handleFitbitFailure(_ error: NetworkError) {
        switch error.type {
        case .unauthenticated: showTemporaryHUD(type: .unauthenticated)
        case .noNetworkConnection: showTemporaryHUD(type: .noNetworkConnection)
        case .unknown(let error, _),
             .failedToParseData(_, let error): showTemporaryHUD(type: .custom(title: R.string.localized.alertTitleCustom(), message: error.localizedDescription))
        case .cancelled: showTemporaryHUD(type: .fitbitFailure)
        default: break
        }
    }

    private func showTemporaryHUD(type: AlertType) {
        guard let window = appDelegate.window else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: window, animated: true, title: type.title, message: type.message)
        hud.hide(animated: true, afterDelay: 3.0)
    }

    private func notificationIsCompleted(remotID: Int) throws -> Bool {
        let realmProvider = RealmProvider()
        let realm = try realmProvider.realm()
        let type = RealmGuideItemNotification.self
        return realm.syncableObject(ofType: type, remoteID: remotID)?.completedAt != nil
    }

    private func dailyPrepIsCompleted(date: ISODate) throws -> Bool {
        let realmProvider = RealmProvider()
        let realm = try realmProvider.realm()
        return realm.objects(DailyPrepResultObject.self).filter("isoDate == %@", date.string).count > 0
    }
}

// MARK: - Morning Interview

extension LaunchHandler {

    func dailyPrep(groupID: String?, notificationID: String, guideItem: Guide.Item?) {
        guard let group = groupID,
            let groupIDIntValue = Int(group),
            let date = NotificationID(string: notificationID).dailyPrepContent,
            let alreadyCompleted = try? dailyPrepIsCompleted(date: date) else {
            let groupIDString = groupID.debugDescription
            log("Cannot show daily prep - groupID: \(groupIDString) notificationID: \(notificationID)", level: .error)
            return
        }
        if alreadyCompleted == true {
            navigate(to: URLScheme.guide.destination)
        } else {
            let coordinator = appDelegate.appCoordinator
            coordinator.presentMorningInterview(groupID: groupIDIntValue, date: date)
        }
    }
}

// MARK: - Weekly Choices

extension LaunchHandler {

    func weeklyChoicesReminder() {
        appDelegate.appCoordinator.presentWeeklyChoicesReminder()
    }

    func weeklyChoiches(completion: (() -> Void)? = nil) {
        let dates = startEndDate()
        appDelegate.appCoordinator.presentWeeklyChoices(forStartDate: dates.startDate,
                                                        endDate: dates.endDate,
                                                        completion: completion)
    }

    func selectStrategies(relatedStrategies: [ContentCollection],
                          selectedIDs: [Int],
                          prepareContentController: PrepareContentViewController,
                          completion: ((_ selectedStrategies: [WeeklyChoice], _ syncManager: SyncManager) -> Void)?) {
        appDelegate.appCoordinator.presentRelatedStrategies(relatedStrategies: relatedStrategies,
                                                            selectedIDs: selectedIDs,
                                                            prepareContentController: prepareContentController,
                                                            completion: completion)
    }

    private func startEndDate() -> (startDate: Date, endDate: Date) {
        let calendar = Calendar.sharedUTC
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

    func randomContent(url: URL, scheme: URLScheme, guideItem: Guide.Item? = nil) {
        guard
            let contentIDString = scheme.queryParametter(url: url),
            let contentID = Int(contentIDString) else { return }
        appDelegate.appCoordinator.presentLearnContentItems(contentID: contentID, guideItem: guideItem)
    }
}

// MARK: - To Be Vision

extension LaunchHandler {

    func toBeVision() {
        appDelegate.appCoordinator.presentToBeVision()
    }
}

// MARK: - ContentCategory - ContentCollection

extension LaunchHandler {

    func contentCategory(collectionID: String?) {
        appDelegate.appCoordinator.presentLearnContentCollection(collectionID: collectionID)
    }
}

// MARK: - FeatureExplainer

extension LaunchHandler {

    func featureExplainer(url: URL, scheme: URLScheme, guideItem: Guide.Item?) {
        guard
            let guideItem = guideItem,
            let contentIDString = scheme.queryParametter(url: url),
            let contentID = Int(contentIDString) else { return }
                appDelegate.appCoordinator.presentFeatureArticelContentItems(contentID: contentID, guideItem: guideItem)
    }

    func contentItem(url: URL, scheme: URLScheme, searchViewController: SearchViewController?) {
        guard
            let contentIDString = scheme.queryParametter(url: url),
            let contentID = Int(contentIDString) else { return }
        appDelegate.appCoordinator.presentContentItem(contentID: contentID, searchViewController: searchViewController)
    }
}
