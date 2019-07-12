//
//  MyQotInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotProfileViewControllerInterface: class {
    func showLoaderView()
    func hideLoaderView()
    func setupView(profile: UserProfileModel, menuItems: [MyQotProfileModel.TableViewPresentationData])
}

protocol MyQotProfilePresenterInterface {
    func showLoaderView()
    func hideLoaderView()
    func setupView(profile: UserProfileModel, menuItems: [MyQotProfileModel.TableViewPresentationData])
}

protocol MyQotProfileInteractorInterface: Interactor {
    func memberSinceText() -> String
    func myProfileText() -> String
    func presentController(for index: Int)
    func getData(_ completion: @escaping (UserProfileModel?) -> Void)
}

protocol MyQotProfileRouterInterface {
    func presentMyLibrary()
    func presentAccountSettings()
    func presentAppSettings()
    func presentSupport()
    func presentAboutTignum()
}
