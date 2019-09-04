//
//  PDFReaderViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 24.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import WebKit
import qot_dal

public class PDFReaderViewController: UIViewController, ScreenZLevelOverlay {
    @IBOutlet private weak var shareButton: UIBarButtonItem!
    @IBOutlet private weak var webViewContainer: UIView!
    private weak var webView: WKWebView!

    var interactor: PDFReaderInteractorInterface?

    @IBAction func didSelectDoneButton(_ sender: UIButton) {
        self.interactor?.didTapDone()
    }

    @IBAction func didSelectRefreshButton(_ sender: UIButton) {
        self.interactor?.didTapReload()
    }

    @IBAction func didSelectShareButton(_ sender: UIButton) {
        self.interactor?.didTapShare()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.interactor?.viewDidLoad()
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueType = .CONTENT_ITEM
        pageTrack.associatedValueId = interactor?.contentItemId()
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

extension PDFReaderViewController: PDFReaderViewControllerInterface {
    func setupView(title: String, url: URL) {
        self.title = title
        self.shareButton.isEnabled = false
        let webView = WKWebView()
        self.webViewContainer.fill(subview: webView)
        self.webView = webView
        webView.load(URLRequest.init(url: url))
        self.navigationController?.hidesBarsOnTap = true
        self.navigationController?.hidesBarsOnSwipe = true
    }

    func reload() {
        self.webView.reloadFromOrigin()
    }

    func enableShareButton(_ enable: Bool) {
        self.shareButton.isEnabled = enable
    }
}

extension PDFReaderViewController {
    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
