//
//  PDFReaderViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 24.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import WebKit

public class PDFReaderViewController: UIViewController {
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
