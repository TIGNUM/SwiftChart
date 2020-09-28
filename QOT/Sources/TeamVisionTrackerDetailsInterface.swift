//
//  TeamVisionTrackerDetailsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol TeamVisionTrackerDetailsViewControllerInterface: class {
    func setupView()
}

protocol TeamVisionTrackerDetailsPresenterInterface {
    func setupView()
}

protocol TeamVisionTrackerDetailsInteractorInterface: Interactor {}

protocol TeamVisionTrackerDetailsRouterInterface {
    func dismiss()
}
