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

    init(presenter: MyVisionPresenterInterface,
         worker: MyVisionWorker,
         router: MyVisionRouter) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    func viewDidLoad() {
        presenter.setupView()
        presenter.showScreenLoader()
        worker.myToBeVision {[weak self] (myVision, status, error) in
            self?.presenter.hideScreenLoader()
            self?.presenter.load(myVision)
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

        activityVC.completionWithItemsHandler = { (activity, success, items, error) in
            // swizzle back to original
            self.swizzleMFMailComposeViewControllerMessageBody()
        }

        router.presentViewController(viewController: activityVC) {
            // after present swizzle for mail
            self.swizzleMFMailComposeViewControllerMessageBody()
        }
    }
}

extension MyVisionInteractor: MyVisionInteractorInterface {

    func showUpdateConfirmationScreen() {
        router.showUpdateConfirmationScreen()
    }

    func showNullState(with title: String, message: String) {
        presenter.showNullState(with: title, message: message)
    }

    func hideNullState() {
        presenter.hideNullState()
    }

    var permissionManager: PermissionsManager {
        return worker.permissionManager
    }

    var headlinePlaceholder: String? {
        return worker.headlinePlaceholder
    }

    var messagePlaceholder: String? {
        return worker.messagePlaceholder
    }

    var myVision: QDMToBeVision? {
        return worker.myVision
    }

    func lastUpdatedVision() -> String? {
        return worker.lastUpdatedVision()
    }

    func isShareBlocked() -> Bool {
        let vision = worker.myVision
        let visionIsNil = vision?.headline == nil && vision?.text == nil
        let visionIsDefault = vision?.text == worker.messagePlaceholder
        return visionIsNil || visionIsDefault
    }

    func saveToBeVision(image: UIImage?, toBeVision: QDMToBeVision) {
        var vision = toBeVision
        do {
            if let visionImage = image {
                let imageUrl = try worker.saveImage(visionImage).absoluteString
                vision.profileImageResource = QDMMediaResource()
                vision.profileImageResource?.localURLString = imageUrl
            }
        } catch {
            qot_dal.log(error.localizedDescription)
        }
        vision.modifiedAt = Date()
        worker.updateMyToBeVision(vision) {[weak self] in
            self?.presenter.load(vision)
        }
    }

    func shareMyToBeVision() {
        worker.visionToShare { (visionToShare) in
            guard let vision = visionToShare else { return }
            self.share(plainText: vision.plainBody ?? "")
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

    func showEditVision() {
        router.showEditVision()
    }

    func openToBeVisionGenerator() {
        router.openToBeVisionGenerator(permissionManager: worker.permissionManager)
    }
}

extension MFMailComposeViewController {
    @objc func setBodySwizzeld(_ body: String, isHTML: Bool) {
        self.setBodySwizzeld(MyVisionWorker.toBeSharedVisionHTML ?? "", isHTML: true)
    }
}
