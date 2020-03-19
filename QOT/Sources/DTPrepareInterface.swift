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
    func getUserPreparation(answer: DTViewModel.Answer,
                            event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void)
    func getUserPreparation(event: DTViewModel.Event?,
                            calendarEvent: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void)
    func getUserPreparation(event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void)
}

protocol DTPrepareRouterInterface {
    func loadShortTBVGenerator(introKey: String, delegate: DTShortTBVDelegate?, completion: (() -> Void)?)
    func presentPrepareResults(_ preparation: QDMUserPreparation?)
    func didUpdatePrepareResults()
    func dismissResultView()
}
