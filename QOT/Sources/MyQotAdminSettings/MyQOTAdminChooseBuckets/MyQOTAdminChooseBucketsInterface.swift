//
//  MyQOTAdminChooseBucketsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQOTAdminChooseBucketsViewControllerInterface: class {
    func setupView()
}

protocol MyQOTAdminChooseBucketsPresenterInterface {
    func setupView()
}

protocol MyQOTAdminChooseBucketsInteractorInterface: Interactor {
    func getHeaderTitle() -> String
}

protocol MyQOTAdminChooseBucketsRouterInterface {
    func dismiss()
}
