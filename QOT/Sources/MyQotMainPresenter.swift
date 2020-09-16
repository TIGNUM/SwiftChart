//
//  MyQotMainPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit
import qot_dal

final class MyQotMainPresenter {

    // MARK: - Properties
    private weak var viewController: MyQotMainViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQotMainViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - KnowingInterface
extension MyQotMainPresenter: MyQotMainPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func deleteItems(at indexPath: [IndexPath], updateIndexPath: [IndexPath],
                     originalIndexPathforUpdateIndexPath: [IndexPath], _ completion: @escaping () -> Void) {
        log("indexPath: \(indexPath)", level: .debug)
        viewController?.deleteItems(at: indexPath, updateIndexPath: updateIndexPath,
                                    originalIndexPathforUpdateIndexPath: originalIndexPathforUpdateIndexPath, completion)
    }

    func inserItems(at indexPath: [IndexPath], updateIndexPath: [IndexPath],
                    originalIndexPathforUpdateIndexPath: [IndexPath], _ completion: @escaping () -> Void) {
        log("indexPath: \(indexPath)", level: .debug)
        viewController?.inserItems(at: indexPath, updateIndexPath: updateIndexPath,
                                   originalIndexPathforUpdateIndexPath: originalIndexPathforUpdateIndexPath, completion)
    }

    func reload() {
        log("viewController?.reload()", level: .debug)
        viewController?.reload()
    }
}
