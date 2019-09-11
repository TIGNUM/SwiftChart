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
    func setupView()
    func presentAlert(title: String, message: String, stayTitle: String, leaveTitle: String)
}

protocol SolveResultsPresenterInterface {
    func present(_ results: SolveResults)
    func setupView()
    func presentAlert(title: String, message: String, stayTitle: String, leaveTitle: String)
}

protocol SolveResultsInteractorInterface: Interactor {
    var hideShowMoreButton: Bool { get }
    var resultType: ResultType { get }
    func save()
    func didTapStrategy(with id: Int)
    func didTapTrigger(_ type: SolveTriggerType)
    func openConfirmationView()
    func deleteModelAndDismiss()
    func dismiss()
    func didTapDone()
    func isPresentingExistingSolve() -> Bool
}

protocol SolveResultsRouterInterface {
    func dismiss()
    func didTapDone()
    func openStrategy(with id: Int)
    func openVisionGenerator()
    func openMindsetShifter()
    func openRecovery()
}
