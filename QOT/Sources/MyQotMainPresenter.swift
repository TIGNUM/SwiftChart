//
//  MyQotMainPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit

final class MyQotMainPresenter {

    // MARK: - Properties
    private weak var viewController: MyQotMainViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQotMainViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - KnowingInterface

extension MyQotMainPresenter: MyQotMainPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func updateView(_ differenceList: StagedChangeset<ArraySectionMyX>) {
        viewController?.updateView(differenceList)
    }

    func reload() {
        viewController?.reload()
    }

//    func updateTeamHeader(teamHeaderItems: [Team.Item]) {
//        viewController?.updateTeamHeader(teamHeaderItems: teamHeaderItems)
//    }
}
