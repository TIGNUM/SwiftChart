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
    private var showSubVCModal: Bool

    init(presenter: MyVisionPresenterInterface, router: MyVisionRouter, showSubVCModal: Bool = false) {
        self.presenter = presenter
        self.router = router
        self.showSubVCModal = showSubVCModal
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
        worker.getToBeVision { [weak self] (_, toBeVision) in
            self?.worker.getRateButtonValues { [weak self] (text, shouldShowSingleMessage, status) in
                self?.presenter.load(toBeVision,
                                     rateText: text,
                                     isRateEnabled: status,
                                     shouldShowSingleMessageRating: shouldShowSingleMessage)
                self?.worker.updateWidget()
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
        worker.getToBeVision { [weak self] (_, myVision) in
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
            self?.worker.getToBeVision { [weak self] (_, toBeVision) in
                guard let strongSelf = self else {
                    return
                }
                self?.router.showTBVData(shouldShowNullState: report?.dates.isEmpty == true,
                                         visionId: toBeVision?.remoteID,
                                         showModal: strongSelf.showSubVCModal)
            }
        }
    }

    func showTracker() {
        router.showTracker(for: nil, showModal: showSubVCModal)
    }

    func showRateScreen(delegate: TBVRateDelegate?) {
        worker.getToBeVision { [weak self] (_, toBeVision) in
            guard let strongSelf = self else {
                return
            }
            if let remoteId = toBeVision?.remoteID {
                strongSelf.router.showRateScreen(with: remoteId, delegate: delegate, showModal: strongSelf.showSubVCModal)
            }
        }
    }

    func showEditVision(isFromNullState: Bool) {
        worker.getToBeVision { [weak self] (_, toBeVision) in
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
