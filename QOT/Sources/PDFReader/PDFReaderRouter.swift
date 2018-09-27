//
//  PDFReaderRouter.swift
//  QOT
//
//  Created by Sanggeon Park on 28.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PDFReaderRouter {

    // MARK: - Properties

    private weak var viewController: PDFReaderViewController?

    // MARK: - Init

    init(viewController: PDFReaderViewController) {
        self.viewController = viewController
    }
}

extension PDFReaderRouter: PDFReaderRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func presentViewController(viewController: UIViewController, completion: (() -> Void)?) {
        self.viewController?.present(viewController, animated: true, completion: completion)
    }

    func showAlert(type: AlertType, handler: (() -> Void)? = nil, handlerDestructive: (() -> Void)? = nil) {
        viewController?.showAlert(type: type, handler: handler, handlerDestructive: handlerDestructive)
    }
}
