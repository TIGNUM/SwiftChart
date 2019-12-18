//
//  MyQOTAdminChooseBucketsPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminChooseBucketsPresenter {

    // MARK: - Properties
    private weak var viewController: MyQOTAdminChooseBucketsViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQOTAdminChooseBucketsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyQOTAdminChooseBucketsInterface
extension MyQOTAdminChooseBucketsPresenter: MyQOTAdminChooseBucketsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
