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
        case myLibrary
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
        showLoaderView()
        getData({ [weak self] (profile) in
            self?.hideLoaderView()
            guard let profile = profile, let menuItems = self?.worker.menuItems else { return }
            self?.presenter.setupView(profile: profile, menuItems: menuItems)
        })
    }
}

// MARK: - MyQotInteractorInterface

extension MyQotProfileInteractor: MyQotProfileInteractorInterface {

    func showLoaderView() {
        presenter.showLoaderView()
    }

    func hideLoaderView() {
        presenter.hideLoaderView()
    }

    func memberSinceText() -> String {
        return worker.memberSinceTxt
    }

    func myProfileText() -> String {
        return worker.myProfileTxt
    }

    func getData(_ completion: @escaping (UserProfileModel?) -> Void) {
        worker.getData { (profile) in
            completion(profile)
        }
    }

    func presentController(for index: Int) {
        let type = controllerType.allCases[index]
        switch type {
        case .myLibrary:
            router.presentMyLibrary()
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
