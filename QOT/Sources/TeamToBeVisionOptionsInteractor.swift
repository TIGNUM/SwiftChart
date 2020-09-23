//
//  TeamToBeVisionOptionsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamToBeVisionOptionsInteractor {

    // MARK: - Properties
    private lazy var worker = TeamToBeVisionOptionsWorker()
    private let presenter: TeamToBeVisionOptionsPresenterInterface!
    private var type = TeamToBeVisionOptionsModel.Types.voting
    private var model = TeamToBeVisionOptionsModel()
    private var remainingDays: Int = 0

    // MARK: - Init
    init(presenter: TeamToBeVisionOptionsPresenterInterface, type: TeamToBeVisionOptionsModel.Types, remainingDays: Int) {
        self.presenter = presenter
        self.type = type
        self.remainingDays = remainingDays
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView(type: type, remainingDays: remainingDays)
    }
}

// MARK: - TeamToBeVisionOptionsInteractorInterface
extension TeamToBeVisionOptionsInteractor: TeamToBeVisionOptionsInteractorInterface {

    var getType: TeamToBeVisionOptionsModel.Types {
        return type
    }

    var daysLeft: Int {
        return remainingDays
    }
}
