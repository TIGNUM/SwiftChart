//
//  PDFReaderInteractor.swift
//  QOT
//
//  Created by Sanggeon Park on 28.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import MessageUI

func swizzleMFMailComposeViewControllerMessageBody() {
    let originalMethod = class_getInstanceMethod(MFMailComposeViewController.self,
                                                 #selector(MFMailComposeViewController.setMessageBody(_:isHTML:)))
    let swizzledMethod = class_getInstanceMethod(MFMailComposeViewController.self,
                                                 #selector(MFMailComposeViewController.setMessageBodySwizzeld(_:isHTML:)))
    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        // switch implementation..
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

final class PDFReaderInteractor {

    // MARK: - Properties

    private let worker: PDFReaderWorker
    private let presenter: PDFReaderPresenterInterface
    private let router: PDFReaderRouterInterface

    static var shareMailTitle: String!
    static var shareMailBody: String!

    private var shareTitle: String!
    private var shareLink: String!

    private var shareContent: Share.ContentItem?

    // MARK: - Init

    init(worker: PDFReaderWorker,
         presenter: PDFReaderPresenterInterface,
         router: PDFReaderRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        prepareShareContent()
    }

    func prepareShareContent() {
        worker.prepareShareContent { (result) in
            switch result {
            case .success(let shareContent) :
                self.shareContent = shareContent
                PDFReaderInteractor.shareMailTitle = shareContent.title
                PDFReaderInteractor.shareMailBody = shareContent.body
            case .failure(let error):
                log("Getting Share Content Failed- \(error)", level: .error)
                self.router.showAlert(type: .message(error.localizedDescription), handler: nil, handlerDestructive: nil)
            }
            self.presenter.enableShareButton(self.shareContent != nil)
        }
    }
}

extension PDFReaderInteractor: PDFReaderInteractorInterface {
    func didTapReload() {
        presenter.reload()
        prepareShareContent()
    }
    func didTapDone() {
        router.dismiss()
    }
    func didTapShare() {
        guard let shareContent = self.shareContent else {
            log("Did select share contentItem without share content.", level: .error)
            return
        }
        // swizzle
        guard let shareURL = URL(string: shareContent.url) else {
            log("Short URL for contentItem is invalid.", level: .error)
            return
        }
        let activityVC = UIActivityViewController(activityItems: [shareContent.title, shareURL], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activity, success, items, error) in
            // swizzle back to original
            swizzleMFMailComposeViewControllerMessageBody()
        }

        router.presentViewController(viewController: activityVC) {
            // after present swizzle for mail
            swizzleMFMailComposeViewControllerMessageBody()
        }
    }
}

extension MFMailComposeViewController {
    @objc func setMessageBodySwizzeld(_ body: String, isHTML: Bool) {
        self.setSubject(PDFReaderInteractor.shareMailTitle)
        self.setMessageBodySwizzeld(PDFReaderInteractor.shareMailBody, isHTML: true)
    }
}
