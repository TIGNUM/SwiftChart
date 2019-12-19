//
//  MyQOTAdminChooseBucketsRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminChooseBucketsRouter {

    // MARK: - Properties
    private weak var viewController: MyQOTAdminChooseBucketsViewController?

    // MARK: - Init
    init(viewController: MyQOTAdminChooseBucketsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyQOTAdminChooseBucketsRouterInterface
extension MyQOTAdminChooseBucketsRouter: MyQOTAdminChooseBucketsRouterInterface {
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
