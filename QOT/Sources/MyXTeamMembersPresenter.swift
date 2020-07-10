//
//  MyXTeamMembersPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class MyXTeamMembersPresenter {

    // MARK: - Properties
    private weak var viewController: MyXTeamMembersViewControllerInterface?

    // MARK: - Init
    init(viewController: MyXTeamMembersViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyXTeamMembersInterface
extension MyXTeamMembersPresenter: MyXTeamMembersPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func updateTeamHeader(teamHeaderItems: [TeamHeader]) {
        viewController?.updateTeamHeader(teamHeaderItems: teamHeaderItems)
    }

    func updateView() {
        viewController?.updateView()
    }
}
