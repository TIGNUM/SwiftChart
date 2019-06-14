//
//  SolveResultsInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol SolveResultsViewControllerInterface: class {
    func load(_ results: SolveResults)
}

protocol SolveResultsPresenterInterface {
    func present(_ results: SolveResults)
}

protocol SolveResultsInteractorInterface: Interactor {
    func save()
    func didTapStrategy(with id: Int)
    func didTapTrigger(_ type: SolveTriggerType)
    func openConfirmationView()
}

protocol SolveResultsRouterInterface {
    func dismiss()
    func openStrategy(with id: Int)
    func openVisionGenerator()
    func openMindsetShifter()
    func openConfirmationView()
}

protocol SolveResultsWorkerInterface {
    var results: SolveResults { get }
    func save(completion: () -> Void)
}
