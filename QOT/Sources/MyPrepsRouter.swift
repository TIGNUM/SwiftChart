//
//  MyPrepsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPrepsRouter {

    // MARK: - Properties
    private weak var viewController: MyPrepsViewController?
    weak var delegate: CoachCollectionViewControllerDelegate?

    // MARK: - Init
    init(viewController: MyPrepsViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyPrepsRouterInterface
extension MyPrepsRouter: MyPrepsRouterInterface {

    func showDeleteConfirmation(delegate: MyPrepsViewControllerDelegate?) {
//        let confirmDeleteViewController = DeleteConfirmationViewController(nibName: "DeleteConfirmationViewController", bundle: nil)
//        confirmDeleteViewController.delegate = delegate
//        viewController.present(confirmDeleteViewController, animated: true, completion: nil)
//TODO - QOT Alert goes here 
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
