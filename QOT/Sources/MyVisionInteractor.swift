//
//  MyVisionInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import MessageUI

final class MyVisionInteractor {

    let presenter: MyVisionPresenterInterface
    let router: MyVisionRouter
    var team: QDMTeam?
    private lazy var worker = MyVisionWorker()
    private var downSyncObserver: NSObjectProtocol?
    private var upSyncObserver: NSObjectProtocol?

    init(presenter: MyVisionPresenterInterface, router: MyVisionRouter, team: QDMTeam?) {
        self.presenter = presenter
        self.router = router
        self.team = team
    }

    deinit {
        if let observer = downSyncObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        if let observer = upSyncObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func viewDidLoad() {
        presenter.setupView()
        didUpdateTBVRelatedData()
        let notificationCenter = NotificationCenter.default
        downSyncObserver = notificationCenter.addObserver(forName: .didFinishSynchronization, object: nil, queue: nil) { [weak self ] (notification) in
            guard let strongSelf = self else {
                return
            }
            guard let syncResult = notification.object as? SyncResultContext,
                syncResult.syncRequestType == .DOWN_SYNC,
                syncResult.hasUpdatedContent else { return }
            switch syncResult.dataType {
            case .MY_TO_BE_VISION_TRACKER, .MY_TO_BE_VISION, .MY_TO_BE_VISION_SHARE:
                strongSelf.didUpdateTBVRelatedData()
            default:
                break
            }
        }
        upSyncObserver = notificationCenter.addObserver(forName: .requestSynchronization, object: nil, queue: nil) { [weak self ] (notification) in
            guard let strongSelf = self else {
                return
            }
            guard let syncResult = notification.object as? SyncRequestContext else { return }
            if syncResult.dataType == .MY_TO_BE_VISION,
                syncResult.syncRequestType == .UP_SYNC {
                strongSelf.didUpdateTBVRelatedData()
            }
        }
    }

    func viewWillAppear() {
        didUpdateTBVRelatedData()
    }

    private func didUpdateTBVRelatedData() {
        if let team = team {
            worker.getTeamToBeVision(for: team) { [weak self] (_, teamVision) in
                self?.worker.getRateButtonValues { [weak self] (text, shouldShowSingleMessage, status) in
                    self?.presenter.load(nil,
                                         teamVision: teamVision,
                                         rateText: text,
                                         isRateEnabled: status,
                                         shouldShowSingleMessageRating: shouldShowSingleMessage)
                    self?.worker.updateWidget()
                }
            }
        } else {
            worker.getToBeVision { [weak self] (_, toBeVision) in
                self?.worker.getRateButtonValues { [weak self] (text, shouldShowSingleMessage, status) in
                    self?.presenter.load(toBeVision,
                                         teamVision: nil,
                                         rateText: text,
                                         isRateEnabled: status,
                                         shouldShowSingleMessageRating: shouldShowSingleMessage)
                    self?.worker.updateWidget()
                }
            }
        }
    }

    private func share(plainText: String) {
        let activityVC = UIActivityViewController(activityItems: [plainText], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.openInIBooks,
                                            UIActivity.ActivityType.airDrop,
                                            UIActivity.ActivityType.postToTencentWeibo,
                                            UIActivity.ActivityType.postToVimeo,
                                            UIActivity.ActivityType.postToFlickr,
                                            UIActivity.ActivityType.addToReadingList,
                                            UIActivity.ActivityType.saveToCameraRoll,
                                            UIActivity.ActivityType.assignToContact,
                                            UIActivity.ActivityType.postToFacebook,
                                            UIActivity.ActivityType.postToTwitter]

        activityVC.completionWithItemsHandler = { [weak self] (activity, success, items, error) in
            // swizzle back to original
            self?.swizzleMFMailComposeViewControllerMessageBody()
        }

        router.showViewController(viewController: activityVC) { [weak self] in
            // after present swizzle for mail
            self?.swizzleMFMailComposeViewControllerMessageBody()
        }
    }
}

extension MyVisionInteractor: MyVisionInteractorInterface {
    func getToBeVision(_ completion: @escaping (QDMToBeVision?) -> Void) {
        worker.getToBeVision { (_, toBeVision) in
            completion(toBeVision)
        }
    }

    func isShareBlocked(_ completion: @escaping (Bool) -> Void) {
        getToBeVision { (toBeVision) in
            completion(toBeVision?.headline == nil && toBeVision?.text == nil)
        }
    }

    func showUpdateConfirmationScreen() {
        presenter.presentTBVUpdateAlert(title: worker.updateAlertTitle,
                                        message: worker.updateAlertMessage,
                                        editTitle: worker.updateAlertEditTitle,
                                        crateNewTitle: worker.updateAlertCreateTitle)
    }

    func showNullState(with title: String, message: String) {
        presenter.showNullState(with: title, message: message)
    }

    func hideNullState() {
        presenter.hideNullState()
    }

    var nullStateSubtitle: String? {
        return worker.nullStateSubtitle
    }

    var teamNullStateSubtitle: String? {
        return worker.teamNullStateSubtitle
    }

    var teamNullStateTitle: String? {
        return worker.teamNullStateTitle
    }

    var nullStateTitle: String? {
        return worker.nullStateTitle
    }

    var emptyTBVTitlePlaceholder: String {
        return worker.emptyTBVTitlePlaceholder
    }

    var emptyTeamTBVTitlePlaceholder: String {
        return worker.emptyTeamTBVTitlePlaceholder
    }

    var emptyTBVTextPlaceholder: String {
        return worker.emptyTBVTextPlaceholder
    }

    var emptyTeamTBVTextPlaceholder: String {
        return worker.emptyTeamTBVTextPlaceholder
    }

    func lastUpdatedVision() -> String? {
        if team != nil {
            return worker.lastUpdatedTeamVision()
        }
        return worker.lastUpdatedVision()
    }

    func saveToBeVision(image: UIImage?) {
        guard let team = team else {
            worker.getToBeVision { [weak self] (_, toBeVision) in
                if var vision = toBeVision {
                    vision.modifiedAt = Date()
                    if let visionImage = image {
                        do {
                            let imageUrl = try self?.worker.saveImage(visionImage).absoluteString
                            vision.profileImageResource = QDMMediaResource()
                            vision.profileImageResource?.localURLString = imageUrl
                        } catch {
                            log(error.localizedDescription)
                        }
                    } else {
                        vision.profileImageResource = nil
                    }

                    self?.worker.updateMyToBeVision(vision) { [weak self] (reponseVision) in
                        self?.didUpdateTBVRelatedData()
                    }
                }
            }
            return
        }

        worker.getTeamToBeVision(for: team) { [weak self] (_, teamVision) in
            if var teamVision = teamVision {
                teamVision.modifiedAt = Date()
                if let teamVisionImage = image {
                    do {
                        let imageUrl = try self?.worker.saveImage(teamVisionImage).absoluteString
                        teamVision.profileImageResource = QDMMediaResource()
                        teamVision.profileImageResource?.localURLString = imageUrl
                    } catch {
                        log(error.localizedDescription)
                    }
                } else {
                    teamVision.profileImageResource = nil
                }

                self?.worker.updateTeamToBeVision(teamVision, team: team) { [weak self] (responseTeamVision) in
                    self?.didUpdateTBVRelatedData()
                }
            }
        }

    }

    func shouldShowWarningIcon(_ completion: @escaping (Bool) -> Void) {
        worker.shouldShowWarningIcon { (show) in
            completion(show)
        }
    }

    func shareToBeVision() {
        guard team == nil else {
            worker.visionToShare { [weak self] (visionToShare) in
                guard let vision = visionToShare else { return }
                self?.share(plainText: vision.plainBody ?? "")

            }
            return
        }
        //       TO DO later: share team TBV
    }




    func swizzleMFMailComposeViewControllerMessageBody() {
        let originalMethod = class_getInstanceMethod(MFMailComposeViewController.self,
                                                     #selector(MFMailComposeViewController.setMessageBody(_:isHTML:)))
        let swizzledMethod = class_getInstanceMethod(MFMailComposeViewController.self,
                                                     #selector(MFMailComposeViewController.setBodySwizzeld(_:isHTML:)))
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            // switch implementation..
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    func showTBVData() {
        guard team != nil else {
            worker.getRatingReport { [weak self] (report) in
                self?.worker.getToBeVision { [weak self] (_, toBeVision) in
                    self?.router.showTBVData(shouldShowNullState: report?.days.isEmpty == true,
                                             visionId: toBeVision?.remoteID)
                }
            }
            return
        }
        //        TO DO: Get Team tbv rating report
    }

    func showTracker() {
        guard team != nil else {
            router.showTracker()
            return
        }
        //      TODO:  Show Team TBV Tracker
    }

    func showRateScreen() {
        guard let team = team else {
            worker.getToBeVision { [weak self] (_, toBeVision) in
                if let remoteId = toBeVision?.remoteID {
                    self?.router.showRateScreen(with: remoteId)
                }
            }
            return
        }
        worker.getTeamToBeVision(for: team) { (_, teamVision) in
            //      TO DO: Rate Screen for Teams
        }
    }

    func showEditVision(isFromNullState: Bool) {
        guard let team = team else {
            worker.getToBeVision { [weak self] (_, toBeVision) in
                self?.router.showEditVision(title: toBeVision?.headline ?? "",
                                            vision: toBeVision?.text ?? "",
                                            isFromNullState: isFromNullState)
            }
            return
        }
        worker.getTeamToBeVision(for: team) { (_, teamVision) in
//            TO DO: Show edit team TBV
//            self?.router.showEditVision(title: teamVision?.headline ?? "",
//                                        vision: teamVision?.text ?? "",
//                                        isFromNullState: isFromNullState)
        }
    }

    func openToBeVisionGenerator() {
        guard team != nil  else {
            router.showTBVGenerator()
            return
        }
//        open team TBV generator
    }
}

extension MFMailComposeViewController {
    @objc func setBodySwizzeld(_ body: String, isHTML: Bool) {
        self.setBodySwizzeld(MyVisionWorker.toBeSharedVisionHTML ?? "", isHTML: true)
    }
}
