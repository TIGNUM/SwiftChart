//
//  halloInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 07.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol halloViewControllerInterface: class {
    func setupView()
}

protocol halloPresenterInterface {
    func setupView()
}

protocol halloInteractorInterface: Interactor {}

protocol halloRouterInterface {
    func dismiss()
}
