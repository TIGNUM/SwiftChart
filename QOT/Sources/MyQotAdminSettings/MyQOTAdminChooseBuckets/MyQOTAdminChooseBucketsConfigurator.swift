//
//  MyQOTAdminChooseBucketsConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQOTAdminChooseBucketsConfigurator {
    static func configure(viewController: MyQOTAdminChooseBucketsViewController) {
        let presenter = MyQOTAdminChooseBucketsPresenter(viewController: viewController)
        let interactor = MyQOTAdminChooseBucketsInteractor(presenter: presenter)
        viewController.interactor = interactor
    }
}
