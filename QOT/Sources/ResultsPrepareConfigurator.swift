//
//  ResultsPrepareConfigurator.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ResultsPrepareConfigurator {
    static func make(_ preparation: QDMUserPreparation?,
                     resultType: ResultType) -> (ResultsPrepareViewController) -> Void {
        return { (viewController) in
            let presenter = ResultsPreparePresenter(viewController: viewController)
            let interactor = ResultsPrepareInteractor(presenter: presenter, preparation, resultType: resultType)
            viewController.interactor = interactor
            viewController.delegate = interactor
            viewController.resultType = resultType
        }
    }
}
