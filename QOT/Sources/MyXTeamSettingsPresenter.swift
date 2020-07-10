//
//  MyXTeamSettingsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class MyXTeamSettingsPresenter {

    // MARK: - Properties
    private weak var viewController: MyXTeamSettingsViewControllerInterface?

    // MARK: - Init
    init(viewController: MyXTeamSettingsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyXTeamSettingsInterface
extension MyXTeamSettingsPresenter: MyXTeamSettingsPresenterInterface {
    func updateTeamHeader(teamHeaderItems: [TeamHeader]) {
         viewController?.updateTeamHeader(teamHeaderItems: teamHeaderItems)
    }

    func present(_ settings: MyXTeamSettingsModel) {
        viewController?.setup(settings)
    }

    func updateView() {
        viewController?.updateView()
    }

    func updateSettingsModel(_ settings: MyXTeamSettingsModel) {
        viewController?.updateSettingsModel(settings)
    }
}
