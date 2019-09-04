//
//  PDFReaderInterface.swift
//  QOT
//
//  Created by Sanggeon Park on 29.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol PDFReaderViewControllerInterface: class {
    func setupView(title: String, url: URL)
    func reload()
    func enableShareButton(_ enable: Bool)
}

protocol PDFReaderPresenterInterface {
    func setupView()
    func reload()
    func enableShareButton(_ enable: Bool)
}

protocol PDFReaderInteractorInterface: Interactor {
    func didTapReload()
    func didTapDone()
    func didTapShare()
    func contentItemId() -> Int?
}

protocol PDFReaderRouterInterface {
    func dismiss()
    func presentViewController(viewController: UIViewController, completion: (() -> Void)?)
    func showAlert(type: AlertType, handler: (() -> Void)?, handlerDestructive: (() -> Void)?)
}
