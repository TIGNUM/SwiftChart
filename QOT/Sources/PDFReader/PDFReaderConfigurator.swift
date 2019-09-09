//
//  PDFReaderConfigurator.swift
//  QOT
//
//  Created by Sanggeon Park on 28.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PDFReaderConfigurator {

    static func make(contentItemID: Int, title: String, url: URL) -> (PDFReaderViewController) -> Void {
        return { (viewController) in
            let router = PDFReaderRouter(viewController: viewController)
            let worker = PDFReaderWorker(contentItemID: contentItemID)
            let presenter = PDFReaderPresenter(viewController: viewController, title: title, url: url)
            let interactor = PDFReaderInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
