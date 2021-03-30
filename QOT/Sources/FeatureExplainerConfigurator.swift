//
//  FeatureExplainerConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class FeatureExplainerConfigurator {
    static func make(viewController: FeatureExplainerViewController?, type: FeatureExplainer.Kind) {
        let presenter = FeatureExplainerPresenter(viewController: viewController)
        let interactor = FeatureExplainerInteractor(presenter: presenter, featureType: type)
        viewController?.interactor = interactor
    }
}
