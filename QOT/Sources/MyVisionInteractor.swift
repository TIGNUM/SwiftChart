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
    let worker: MyVisionWorker
    let router: MyVisionRouter
    private var downSyncObserver: NSObjectProtocol?
    private var upSyncObserver: NSObjectProtocol?

    init(presenter: MyVisionPresenterInterface,
         worker: MyVisionWorker,
         router: MyVisionRouter) {
        self.worker = worker
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
        presenter.setupView()
        didUpdateTBVRelatedData()
        let notificationCenter = NotificationCenter.default
        downSyncObserver = notificationCenter.addObserver(forName: .didFinishSynchronization, object: nil, queue: nil) { [weak self ] (notification) in
            guard let strongSelf = self else {
                return
            }
            guard let syncResult = notification.object as? SyncResultContext else { return }
            if syncResult.dataType == .MY_TO_BE_VISION, syncResult.syncRequestType == .DOWN_SYNC {
                strongSelf.didUpdateTBVRelatedData()
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
        worker.getData {[weak self] (initialized) in
            let (text, shouldShowSingleMessage, status) = self?.worker.updateRateButton() ?? ("", nil, false)
            self?.presenter.load(self?.myVision, rateText: text, isRateEnabled: status, shouldShowSingleMessageRating: shouldShowSingleMessage)
            self?.worker.updateWidget()
        }
    }

    private func didUpdateTBVRelatedData() {
        worker.getData {[weak self] (initialized) in
            if !initialized {
                self?.presenter.showScreenLoader()
                return
            }

            self?.presenter.hideScreenLoader()
            let (text, shouldShowSingleMessage, status) = self?.worker.updateRateButton() ?? ("", nil, false)
            self?.presenter.load(self?.myVision, rateText: text, isRateEnabled: status, shouldShowSingleMessageRating: shouldShowSingleMessage)
            self?.worker.updateWidget()
        }
    }

    private func share(plainText: String) {
        let activityVC = UIActivityViewController(activityItems: [plainText], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.openInIBooks,
                                            UIActivityType.airDrop,
                                            UIActivityType.postToTencentWeibo,
                                            UIActivityType.postToVimeo,
                                            UIActivityType.postToFlickr,
                                            UIActivityType.addToReadingList,
                                            UIActivityType.saveToCameraRoll,
                                            UIActivityType.assignToContact,
                                            UIActivityType.postToFacebook,
                                            UIActivityType.postToTwitter]

        activityVC.completionWithItemsHandler = { [weak self] (activity, success, items, error) in
            // swizzle back to original
            self?.swizzleMFMailComposeViewControllerMessageBody()
        }

        router.presentViewController(viewController: activityVC) { [weak self] in
            // after present swizzle for mail
            self?.swizzleMFMailComposeViewControllerMessageBody()
        }
    }
}

extension MyVisionInteractor: MyVisionInteractorInterface {

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

    var nullStateTitle: String? {
        return worker.nullStateTitle
    }

    var myVision: QDMToBeVision? {
        return worker.myVision
    }

    var emptyTBVTextPlaceholder: String {
        return worker.emptyTBVTextPlaceholder
    }

    func lastUpdatedVision() -> String? {
        return worker.lastUpdatedVision()
    }

    func isShareBlocked() -> Bool {
        let vision = worker.myVision
        let visionIsNil = vision?.headline == nil && vision?.text == nil
        return visionIsNil
    }

    func saveToBeVision(image: UIImage?, toBeVision: QDMToBeVision) {
        var vision = toBeVision
        if let visionImage = image {
            do {
                let imageUrl = try worker.saveImage(visionImage).absoluteString
                vision.profileImageResource = QDMMediaResource()
                vision.profileImageResource?.localURLString = imageUrl
            } catch {
                qot_dal.log(error.localizedDescription)
            }
        } else {
            vision.modifiedAt = Date()
            vision.profileImageResource = nil
        }

        worker.updateMyToBeVision(vision) { [weak self] in
            self?.didUpdateTBVRelatedData()
        }
    }

    func shouldShowWarningIcon() -> Bool {
        return worker.shouldShowWarningIcon()
    }

    func shareMyToBeVision() {
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
        let shouldShowNullState = worker.myVisionReport?.days.count == 0
        router.showTBVData(shouldShowNullState: shouldShowNullState, visionId: worker.myVision?.remoteID)
    }

    func showTracker() {
        router.showTracker()
    }

    func showRateScreen(with id: Int) {
        router.showRateScreen(with: id)
    }

    func showEditVision(isFromNullState: Bool) {
        router.showEditVision(title: myVision?.headline ?? "", vision: myVision?.text ?? "", isFromNullState: isFromNullState)
    }

    func openToBeVisionGenerator() {
        router.openToBeVisionGenerator()
    }
}

extension MFMailComposeViewController {
    @objc func setBodySwizzeld(_ body: String, isHTML: Bool) {
        self.setBodySwizzeld(MyVisionWorker.toBeSharedVisionHTML ?? "", isHTML: true)
    }
}
