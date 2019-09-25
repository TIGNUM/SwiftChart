//
//  SolveResultsInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol SolveResultsViewControllerInterface: class {
    func load(_ resultViewModel: SolveResult, isFollowUpActive: Bool)
    func setupView()
}

protocol SolveResultsPresenterInterface {
    func present(_ resultViewModel: SolveResult, isFollowUpActive: Bool)
    func setupView()
}

protocol SolveResultsInteractorInterface: Interactor {
    var hideShowMoreButton: Bool { get }
    var resultType: ResultType { get }
    func save(solveFollowUp: Bool)
    func updateSolve(followUp: Bool)
    func deleteRecovery()
}

protocol SolveResultsRouterInterface {
    func dismiss()
    func openStrategy(with id: Int)
    func openVisionGenerator()
    func openMindsetShifter()
    func openRecovery()
    func presentFeedback()
}
