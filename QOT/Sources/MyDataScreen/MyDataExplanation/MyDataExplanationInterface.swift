//
//  MyDataExplanationInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyDataExplanationViewControllerInterface: class {
    func setupView()
    func setup(for myDataExplanationSection: MyDataExplanationModel, myDataExplanationHeaderTitle: String)
}

protocol MyDataExplanationPresenterInterface {
    func setupView()
    func present(for myDataExplanationSection: MyDataExplanationModel, myDataExplanationHeaderTitle: String)
}

protocol MyDataExplanationInteractorInterface: Interactor {}

protocol MyDataExplanationRouterInterface {
    func dismiss()
}

protocol MyDataExplanationWorkerInterface {
    func myDataExplanationSections() -> MyDataExplanationModel
}
