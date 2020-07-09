//
//  MyXTeamMembersInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class MyXTeamMembersInteractor {

    // MARK: - Properties
    private lazy var worker = MyXTeamMembersWorker()
    private let presenter: MyXTeamMembersPresenterInterface!

    // MARK: - Init
    init(presenter: MyXTeamMembersPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyXTeamMembersInteractorInterface
extension MyXTeamMembersInteractor: MyXTeamMembersInteractorInterface {

}
