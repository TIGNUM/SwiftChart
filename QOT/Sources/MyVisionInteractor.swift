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
    private lazy var worker = MyVisionWorker()
    private var downSyncObserver: NSObjectProtocol?
    private var upSyncObserver: NSObjectProtocol?

    init(presenter: MyVisionPresenterInterface, router: MyVisionRouter) {
        self.presenter = presenter
        self.router = router
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
        addObservers()
        presenter.setupView()
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

private extension MyVisionInteractor {
    func addObservers() {
        let notificationCenter = NotificationCenter.default
        downSyncObserver = notificationCenter.addObserver(forName: .didFinishSynchronization,
                                                          object: nil,
                                                          queue: .main) { [weak self ] (notification) in
            self?.handleDownSyncResult(notification)
        }

        upSyncObserver = notificationCenter.addObserver(forName: .requestSynchronization,
                                                        object: nil,
                                                        queue: .main) { [weak self ] (notification) in
            self?.handleUpSyncResult(notification)
        }
    }

    func handleDownSyncResult(_ notification: Notification) {
        if
            let sync = notification.object as? SyncResultContext,
            sync.syncRequestType == .DOWN_SYNC,
            sync.hasUpdatedContent {

            switch sync.dataType {
            case .MY_TO_BE_VISION_TRACKER,
                 .MY_TO_BE_VISION,
                 .MY_TO_BE_VISION_SHARE: updateTBVData()
            default: break
            }
        }
    }

    func handleUpSyncResult(_ notification: Notification) {
        if
            let sync = notification.object as? SyncRequestContext,
            sync.syncRequestType == .UP_SYNC,
            sync.dataType == .MY_TO_BE_VISION {

            updateTBVData()
        }
    }
}

extension MyVisionInteractor: MyVisionInteractorInterface {
    func updateTBVData() {
        worker.getRateButtonValues { [weak self] (ratingView, myVision) in
            self?.presenter.load(ratingView: ratingView, myVision: myVision)
            self?.worker.updateWidget()
        }
    }

    func getToBeVision(_ completion: @escaping (QDMToBeVision?) -> Void) {
        worker.getToBeVision { (toBeVision) in
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

    func showNullState(with title: String, message: String, writeMessage: String) {
        presenter.showNullState(with: title, message: message, writeMessage: writeMessage)
    }

    func hideNullState() {
        presenter.hideNullState()
    }

    var nullStateSubtitle: String? {
        return worker.nullStateSubtitle
    }

    var nullStateTitle: String? {
        return worker.nullStateTitle
    }

    var nullStateCTA: String? {
        worker.nullStateCTA
    }

    var emptyTBVTitlePlaceholder: String {
        return worker.emptyTBVTitlePlaceholder
    }

    var emptyTBVTextPlaceholder: String {
        return worker.emptyTBVTextPlaceholder
    }

    func lastUpdatedVision() -> String? {
        return worker.lastUpdatedVision()
    }

    func saveToBeVision(image: UIImage?) {
        getToBeVision { [weak self] (myVision) in
            if var myVision = myVision {
                myVision.modifiedAt = Date()
                if let myVisionImage = image {
                    do {
                        let imageUrl = try self?.worker.saveImage(myVisionImage).absoluteString
                        myVision.profileImageResource = QDMMediaResource()
                        myVision.profileImageResource?.localURLString = imageUrl
                    } catch {
                        log(error.localizedDescription)
                    }
                } else {
                    myVision.profileImageResource = nil
                }

                self?.worker.updateMyToBeVision(myVision) { [weak self] (responseMyVision) in
                    self?.updateTBVData()
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
        worker.visionToShare { [weak self] (visionToShare) in
            guard let vision = visionToShare else { return }
            self?.share(plainText: vision.plainBody ?? "")
        }
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
        worker.getRatingReport { [weak self] (report) in
            self?.getToBeVision { [weak self] (toBeVision) in
                self?.router.showTBVData(shouldShowNullState: report?.dates.isEmpty == true,
                                         visionId: toBeVision?.remoteID)
            }
        }
    }

    func showTracker() {
        router.showTracker()
    }

    func showRateScreen() {
        getToBeVision { [weak self] (toBeVision) in
            if let remoteId = toBeVision?.remoteID {
                self?.router.showRateScreen(with: remoteId)
            }
        }
    }

    func showEditVision(isFromNullState: Bool) {
        getToBeVision { [weak self] (toBeVision) in
            self?.router.showEditVision(title: toBeVision?.headline ?? "",
                                        vision: toBeVision?.text ?? "",
                                        isFromNullState: isFromNullState,
                                        team: nil)
        }
    }

    func openToBeVisionGenerator() {
        router.showTBVGenerator()
    }
}

extension MFMailComposeViewController {
    @objc func setBodySwizzeld(_ body: String, isHTML: Bool) {
        self.setBodySwizzeld(MyVisionWorker.toBeSharedVisionHTML ?? "", isHTML: true)
    }
}
