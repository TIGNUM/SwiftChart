//
//  FeatureExplainerInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol FeatureExplainerViewControllerInterface: class {
    func setupView(_ viewModel: FeatureExplainer.ViewModel)
}

protocol FeatureExplainerPresenterInterface {
    func setupView(_ content: QDMContentCollection?, type: FeatureExplainer.Kind?)
}

protocol FeatureExplainerInteractorInterface: Interactor {
    var getFeatureType: FeatureExplainer.Kind { get }
}

protocol FeatureExplainerRouterInterface {
   func didTapGetStarted(_ featureType: FeatureExplainer.Kind) 
}
