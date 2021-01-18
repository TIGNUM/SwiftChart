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
    // MARK: - Properties

    private let worker: MyQotProfileWorker
    private let presenter: MyQotProfilePresenterInterface
    private let router: MyQotProfileRouterInterface
    private var controllerTypes: [ProfileItemControllerType] = [.accountSettings, .appSettings, .support, .aboutTignum]
    private var menuItems = [MyQotProfileModel.TableViewPresentationData]()
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
        updateMenuItems()
        updateViewData()
        _ = NotificationCenter.default.addObserver(forName: .updatedTeams,
                                                   object: nil,
                                                   queue: .main) { [weak self] _ in
            self?.updateViewData()
        }
    }

    @objc func updateViewData() {
        getData({ [weak self] (_) in
            SettingService.main.getSettingFor(key: SettingKey.SystemDevelopmentMode) { [weak self] (setting, _, _) in
                self?.worker.developmentMode = setting?.booleanValue ?? false
                var controllerTypes: [ProfileItemControllerType] = [.accountSettings, .appSettings]
                if self?.worker.hasTeam == true {
                    controllerTypes.append(.teamSettings)
                }
                controllerTypes.append(contentsOf: [.support, .aboutTignum])
                if self?.worker.developmentMode == true {
                    controllerTypes.append(.adminSettings)
                }
                self?.updateControllerTypes(controllerTypes)
                self?.presenter.updateView()
            }
        })
    }

    func viewDidAppear() {
        updateViewData()
    }

    func updateControllerTypes(_ types: [ProfileItemControllerType]) {
        controllerTypes = types
        updateMenuItems()
    }

    func updateMenuItems() {
        menuItems = worker.menuItems(for: self.controllerTypes)
    }
}

// MARK: - MyQotInteractorInterface

extension MyQotProfileInteractor: MyQotProfileInteractorInterface {
    func getProfile() -> UserProfileModel? {
        return worker.userProfile
    }

    func getMenuItems() -> [MyQotProfileModel.TableViewPresentationData] {
        return menuItems
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
        guard index < controllerTypes.count else { return }
        let type = controllerTypes[index]
        switch type {
        case .accountSettings:
            router.presentAccountSettings()
        case .appSettings:
            router.presentAppSettings()
        case .teamSettings:
            router.presentTeamSettings()
        case .support:
            router.presentSupport()
        case .aboutTignum:
            router.presentAboutTignum()
        case .adminSettings:
            router.presentAdminSettings()
        }
    }
}
