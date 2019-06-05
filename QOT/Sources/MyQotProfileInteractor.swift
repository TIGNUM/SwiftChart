//
//  MyQotInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfileInteractor {

    private enum controllerType: Int, CaseIterable {
        case accountSettings
        case appSettings
        case support
        case aboutTignum
    }

    // MARK: - Properties

    private let worker: MyQotProfileWorker
    private let presenter: MyQotProfilePresenterInterface
    private let router: MyQotProfileRouterInterface

    // MARK: - Init

    init(worker: MyQotProfileWorker,
        presenter: MyQotProfilePresenterInterface,
        router: MyQotProfileRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotInteractorInterface

extension MyQotProfileInteractor: MyQotProfileInteractorInterface {

    var memberSinceText: String {
        return worker.memberSinceText
    }

    var myProfileText: String {
        return worker.myProfileText
    }

    var userProfile: UserProfileModel? {
        return worker.profile()
    }

    var menuItems: [MyQotProfileModel.TableViewPresentationData] {
        return worker.menuItems
    }

    func presentController(for index: Int) {
        let type = controllerType.allCases[index]
        switch type {
        case .accountSettings:
            router.presentAccountSettings()
        case .appSettings:
            router.presentAppSettings()
        case .support:
            router.presentSupport()
        case .aboutTignum:
            router.presentAboutTignum()
        }
    }
}
