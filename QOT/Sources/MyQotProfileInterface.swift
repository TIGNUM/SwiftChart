//
//  MyQotInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotProfileViewControllerInterface: class {
    func setupView()
}

protocol MyQotProfilePresenterInterface {
    func setupView()
}

protocol MyQotProfileInteractorInterface: Interactor {
    func presentController(for index: Int)
    var myProfileText: String { get }
    var memberSinceText: String { get }
    var userProfile: UserProfileModel? { get }
    var menuItems: [MyQotProfileModel.TableViewPresentationData] { get }
}

protocol MyQotProfileRouterInterface {
    func presentAccountSettings()
    func presentAppSettings()
    func presentSupport()
    func presentAboutTignum()
}
