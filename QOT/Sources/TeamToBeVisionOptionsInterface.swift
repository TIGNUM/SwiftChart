//
//  TeamToBeVisionOptionsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol TeamToBeVisionOptionsViewControllerInterface: class {
     func setupView(_ options: TeamToBeVisionOptionsModel, type: TeamToBeVisionOptionsModel.Types, remainingDays: Int)
}

protocol TeamToBeVisionOptionsPresenterInterface {
    func setupView(_ options: TeamToBeVisionOptionsModel, type: TeamToBeVisionOptionsModel.Types, remainingDays: Int)
}

protocol TeamToBeVisionOptionsInteractorInterface: Interactor {
    var getType: TeamToBeVisionOptionsModel.Types { get }
}

protocol TeamToBeVisionOptionsRouterInterface {
    func dismiss()
}
