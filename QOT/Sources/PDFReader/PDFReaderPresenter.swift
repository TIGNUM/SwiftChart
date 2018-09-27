//
//  PDFReaderPresenter.swift
//  QOT
//
//  Created by Sanggeon Park on 28.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PDFReaderPresenter {

    // MARK: - Properties

    private weak var viewController: PDFReaderViewControllerInterface?
    private let title: String!
    private let url: URL!

    // MARK: - Init

    init(viewController: PDFReaderViewControllerInterface, title: String, url: URL) {
        self.viewController = viewController
        self.title = title
        self.url = url
    }
}

extension PDFReaderPresenter: PDFReaderPresenterInterface {
    func setupView() {
        self.viewController?.setupView(title: title, url: url)
    }

    func reload() {
        self.viewController?.reload()
    }

    func enableShareButton(_ enable: Bool) {
        self.viewController?.enableShareButton(enable)
    }
}
