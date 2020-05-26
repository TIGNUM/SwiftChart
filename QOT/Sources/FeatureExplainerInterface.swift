//
//  FeatureExplainerInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol FeatureExplainerViewControllerInterface: class {
    func setupView()
}

protocol FeatureExplainerPresenterInterface {
    func setupView()
}

protocol FeatureExplainerInteractorInterface: Interactor {}

protocol FeatureExplainerRouterInterface {
    func dismiss()
}
