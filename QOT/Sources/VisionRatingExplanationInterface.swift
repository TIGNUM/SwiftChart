//
//  VisionRatingExplanationInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol VisionRatingExplanationViewControllerInterface: class {
    func setupView()
}

protocol VisionRatingExplanationPresenterInterface {
    func setupView()
}

protocol VisionRatingExplanationInteractorInterface: Interactor {}

protocol VisionRatingExplanationRouterInterface {
    func dismiss()
}
