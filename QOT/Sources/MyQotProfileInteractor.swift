//
//  MyQotInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotProfileInteractor {

    private enum controllerType: Int, CaseIterable {
        case accountSettings
        case appSettings
        case support
        case aboutTignum
        case teamSettings
        case adminSettings

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
        getData({ [weak self] (profile) in
            SettingService.main.getSettingFor(key: SettingKey.SystemDevelopmentMode) { [weak self] (setting, _, _) in
                self?.worker.developmentMode = setting?.booleanValue ?? false
                self?.presenter.updateView()
            }
        })
    }
}

// MARK: - MyQotInteractorInterface

extension MyQotProfileInteractor: MyQotProfileInteractorInterface {
    func getProfile() -> UserProfileModel? {
        return worker.userProfile
    }

    func getMenuItems() -> [MyQotProfileModel.TableViewPresentationData] {
        return worker.menuItems()
    }

    func memberSinceText() -> String {
        return worker.memberSinceText
    }

    func myProfileText() -> String {
        return worker.myProfileText
    }

    func getData(_ completion: @escaping (UserProfileModel?) -> Void) {
        worker.getData { (profile) in
            completion(profile)
        }
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
        case .adminSettings:
            router.presentAdminSettings()
        case .teamSettings:
            router.presentTeamSettings()
        }
    }
}
