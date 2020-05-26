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
    static func make() -> (FeatureExplainerViewController) -> Void {
        return { (viewController) in
            let router = FeatureExplainerRouter(viewController: viewController)
            let worker = FeatureExplainerWorker(contentService: qot_dal.ContentService.main)
            let presenter = FeatureExplainerPresenter(viewController: viewController)
            let interactor = FeatureExplainerInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
