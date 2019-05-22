//
//  MindsetShifterChecklistPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MindsetShifterChecklistPresenter {

    // MARK: - Properties

    private weak var viewController: MindsetShifterChecklistViewControllerInterface?

    // MARK: - Init

    init(viewController: MindsetShifterChecklistViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MindsetShifterChecklistInterface

extension MindsetShifterChecklistPresenter: MindsetShifterChecklistPresenterInterface {

    func load(_ model: MindsetShifterChecklistModel) {
        viewController?.load(model)
    }
}
