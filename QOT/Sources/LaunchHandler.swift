//
//  LaunchHandler.swift
//  QOT
//
//  Created by Moucheg Mouradian on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import SVProgressHUD
import os.log

enum LaunchOption: String {
    case edit
}

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
                 searchViewController: SearchViewController? = nil,
                 articleItemController: ArticleItemViewController? = nil) {
        guard let host = url.host, let scheme = URLScheme(rawValue: host) else {
            processExternal(url: url)
            return
        }

        if !appDelegate.appCoordinator.isReadyToOpenURL() {
            RestartHelper.setRestartURL(url)
            return
        }
        RestartHelper.clearRestartRouteInfo()

        var options: [LaunchOption: String?] = [:]
        for queryItem in url.queryItems() {
            if let option = LaunchOption(rawValue: queryItem.name) {
                options[option] = queryItem.value
            }
        }

        switch scheme {
        case .dailyPrep: dailyPrep(groupID: scheme.queryParameter(url: url),
                                   notificationID: notificationID,
                                   guideItem: guideItem)
        case .fitbit: fitbit(accessToken: scheme.queryParameter(url: url))
        case .preparation: preparation(localID: url.absoluteString.components(separatedBy: scheme.queryName).last)
        case .randomContent: randomContent(url: url, scheme: scheme, guideItem: guideItem)
        case .myPreps: navigate(to: scheme.destination)
        case .toBeVision: toBeVision(articleItemController: articleItemController, options: options)
        case .weeklyPeakPerformance: navigate(to: scheme.destination)
        case .contentCategory: contentCategory(collectionID: scheme.queryParameter(url: url))
        case .featureExplainer: featureExplainer(url: url, scheme: scheme, guideItem: guideItem)
        case .strategies: navigate(to: scheme.destination)
        case .meUniverse: navigate(to: scheme.destination)
        case .preferencesSyncCalendar: appDelegate.appCoordinator.presentCalendar(from: articleItemController)
        case .preferencesNotification: appDelegate.appCoordinator.presentNotificationsSettings()
        case .addSensor: _ = appDelegate.appCoordinator.presentAddSensor(from: articleItemController)
        case .fitbitAuthrefresh: appDelegate.appCoordinator.presentAddSensor(from: articleItemController)
        case .meMyWhy: navigate(to: scheme.destination) // TODO the middleButtons are different here.
        case .meActivity: navigateToMeCharts(sector: .activity)
        case .meIntensity: navigateToMeCharts(sector: .intensity)
        case .meMeeting: navigateToMeCharts(sector: .meetings)
        case .meSleep: navigateToMeCharts(sector: .sleep)
        case .meQotPartner: return
        case .prepare: navigate(to: scheme.destination)
        case .prepareProblem: navigateToPrepare(scheme.destination)
        case .prepareEvent: navigateToPrepare(scheme.destination)
        case .prepareDay: navigateToPrepare(scheme.destination)
        case .comingEvent:
            navigateToPrepare(scheme.destination, completion: {
                self.appDelegate.appCoordinator.presentComingEvent()
            })
        case .library: appDelegate.appCoordinator.presentLibrary()
        case .profile: appDelegate.appCoordinator.presentProfile(options: options)
        case .guide: navigate(to: scheme.destination)
        case .latestWhatsHotArticle: navigate(to: scheme.destination)
        case .contentItem: contentItem(url: url, scheme: scheme, searchViewController: searchViewController)
        case .signingVerificationCode: signingVerificationCode(url: url)
        case .siriSettings: appDelegate.appCoordinator.navigateToSiriSettings()
        case .qrcode0001,
             .qrcode0002,
             .qrcode0003,
             .qrcode0004: appDelegate.appCoordinator.presentQRCodeURL(url)
        default:
            return
        }
    }

    func processExternal(url: URL) {
        guard let scheme = url.scheme else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }

        guard let schemeEnum = URLScheme(rawValue: scheme) else { return }
        guard let alternative = URL(string: schemeEnum.alternativeURLString) else { return }
        UIApplication.shared.open(alternative, options: [:], completionHandler: nil)
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

    func navigateToPrepare(_ destination: AppCoordinator.Router.Destination?, completion: (() -> Void)? = nil) {
        guard let destination = destination else { return }
        appDelegate.appCoordinator.presentPrepare(destination)
        completion?()
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
        guard let accessToken = accessToken else {
            showTemporaryHUD(type: .fitbitFailure)
            return
        }

        SVProgressHUD.show()
        do {
            let body = try ["accessToken": accessToken].toJSON().serialize()
            let request = FitbitTokenRequest(endpoint: .fitbitToken, body: body)

            let networkManager = appDelegate.appCoordinator.networkManager
            networkManager.request(request, parser: GenericParser.parse) { (result: (Result<(), NetworkError>)) in
                SVProgressHUD.dismiss()
                switch result {
                case .success:
                    self.showTemporaryHUD(type: .fitbitSuccess)
                case .failure(let error):
                    self.handleFitbitFailure(error)
                }
            }
        } catch let error {
            SVProgressHUD.dismiss()
            self.showTemporaryHUD(type: .custom(title: R.string.localized.alertTitleCustom(),
                                                message: error.localizedDescription))
        }
    }

    private func handleFitbitFailure(_ error: NetworkError) {
        switch error.type {
        case .unauthenticated: showTemporaryHUD(type: .unauthenticated)
        case .noNetworkConnection: showTemporaryHUD(type: .noNetworkConnection)
        case .unknown(let error, _),
             .failedToParseData(_, let error):
            showTemporaryHUD(type: .custom(title: R.string.localized.alertTitleCustom(),
                                           message: error.localizedDescription))
        case .cancelled: showTemporaryHUD(type: .fitbitFailure)
        default: break
        }
    }

    private func showTemporaryHUD(type: AlertType) {
        var fullMessage: String = ""
        if let title = type.title {
            fullMessage = title
            if type.message != nil {
                fullMessage += "\n"
            }
        }
        if let message = type.message {
            fullMessage.append(message)
        }
        if !fullMessage.isEmpty {
            SVProgressHUD.showInfo(withStatus: fullMessage)
        }
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
            appDelegate.appCoordinator.presentMorningInterview(groupID: groupIDIntValue, date: date)
        }
    }
}

// MARK: - Random Content

extension LaunchHandler {

    func randomContent(url: URL, scheme: URLScheme, guideItem: Guide.Item? = nil) {
        guard
            let contentIDString = scheme.queryParameter(url: url),
            let contentID = Int(contentIDString) else { return }
        let identifier = R.storyboard.main.qotArticleViewController.identifier
        if let controller = R.storyboard
            .main().instantiateViewController(withIdentifier: identifier) as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: contentID, viewController: controller)
            baseRootViewController?.present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: - To Be Vision

extension LaunchHandler {

    func toBeVision(articleItemController: ArticleItemViewController?, options: [LaunchOption: String?]) {
        appDelegate.appCoordinator.presentToBeVision(articleItemController: articleItemController, options: options)
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
        if
            let guideItem = guideItem,
            let contentIDString = scheme.queryParameter(url: url),
            let contentID = Int(contentIDString) {
            if guideItem.link?.description == "qot://feature-explainer?contentID=100101" { // QOT Benefits
                appDelegate.appCoordinator.presentContentItemSettings(contentID: contentID,
                                                                      controller: appDelegate.window?.rootViewController,
                                                                      pageName: .featureExplainer)
            } else {
                appDelegate.appCoordinator.presentFeatureArticelContentItems(contentID: contentID,
                                                                             guideItem: guideItem)
            }
        } else if
            let contentIDString = scheme.queryParameter(url: url),
            let contentID = Int(contentIDString),
            let notificationIDString = scheme.pushNotificationID(url: url),
            let notificationID = Int(notificationIDString) {
            appDelegate.appCoordinator.presentFeatureArticelContentItems(contentID: contentID,
                                                                         notificationID: notificationID)
        }
    }

    func contentItem(url: URL, scheme: URLScheme, searchViewController: SearchViewController?) {
        guard
            let contentIDString = scheme.queryParameter(url: url),
            let contentID = Int(contentIDString) else { return }
        appDelegate.appCoordinator.presentContentItem(contentID: contentID, searchViewController: searchViewController)
    }
}

// MARK: - SigningVerificationCode

extension LaunchHandler {

    func signingVerificationCode(url: URL) {
        guard url.pathComponents.count == 4 else { return }
        let verificationCode = url.pathComponents[1]
        let email = url.pathComponents[3]
        appDelegate.appCoordinator.presentSigningVerificationView(code: verificationCode, email: email)
    }
}
