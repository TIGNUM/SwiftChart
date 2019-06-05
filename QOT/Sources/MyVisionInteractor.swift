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
        worker.setMyToBeVisionReminder(false)
        worker.myToBeVision {[weak self] (myVision, status, error) in
            self?.worker.setMyToBeVisionReminder(false)
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

    var permissionManager: PermissionsManager {
        return worker.permissionManager
    }

    var headlinePlaceholder: String? {
        return worker.headlinePlaceholder
    }

    var messagePlaceholder: String? {
        return worker.messagePlaceholder
    }

    var trackablePageObject: PageObject? {
        return worker.trackablePageObject
    }

    var myVision: QDMToBeVision? {
        return worker.myVision
    }

    func updateToBeVision() {
        worker.myToBeVision {[weak self] (myVision, status, error) in
            if status == true {
                self?.presenter.load(myVision)
            }
        }
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
        do {
            var vision = toBeVision
            if let visionImage = image {
                let imageUrl = try worker.saveImage(visionImage).absoluteString
                vision.profileImageResource = QDMMediaResource()
                vision.profileImageResource?.localURLString = imageUrl
                vision.modifiedAt = Date()
            }
            worker.updateMyToBeVision(vision) {[weak self] in
                self?.updateToBeVision()
            }
        } catch {
            qot_dal.log(error.localizedDescription)
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
        worker.permissionManager
        router.openToBeVisionGenerator(permissionManager: worker.permissionManager)
    }
}

extension MFMailComposeViewController {
    @objc func setBodySwizzeld(_ body: String, isHTML: Bool) {
        self.setBodySwizzeld(MyVisionWorker.toBeSharedVisionHTML ?? "", isHTML: true)
    }
}
