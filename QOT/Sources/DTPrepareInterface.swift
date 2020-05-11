//
//  DTPrepareInterface.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import EventKit
import qot_dal

protocol DTPrepareViewControllerInterface: class {}

protocol DTPreparePresenterInterface {}

protocol DTPrepareInteractorInterface: Interactor {
    func getUserPreparationDaily(answer: DTViewModel.Answer,
                                 _ completion: @escaping (QDMUserPreparation?) -> Void)
    func getUserPreparationCritical(answerFilter: String,
                                    _ completion: @escaping (QDMUserPreparation?) -> Void)
    func createUserPreparation(from existingPreparation: QDMUserPreparation?,
                               _ completion: @escaping (QDMUserPreparation?) -> Void)
}

protocol DTPrepareRouterInterface {
    func loadShortTBVGenerator(introKey: String, delegate: DTShortTBVDelegate?, completion: (() -> Void)?)
    func presentPrepareResults(_ preparation: QDMUserPreparation?)
    func didUpdatePrepareResults()
    func dismissResultView()
}
