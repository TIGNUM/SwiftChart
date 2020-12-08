//
//  BaseDailyBriefDetailsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol BaseDailyBriefDetailsViewControllerInterface: class {
    func setupView()
    func reloadTableView()
    func showAlert(message: String?)
    func presentMyDataScreen()
    func showCustomizeTarget()
    func showTBV()
    func presentMindsetResults(for mindsetShifter: QDMMindsetShifter?)
    func presentPrepareResults(for preparation: QDMUserPreparation?)
    func saveAnswerValue(_ value: Int, from cell: UITableViewCell)
    func didUpdateLevel5(with model: Level5ViewModel)
    func didUpdateImpactReadiness(with model: ImpactReadinessCellViewModel)
    func showTeamTBV(_ team: QDMTeam)
    func presentStrategyList(strategyID: Int?)
    func openTools(toolID: Int?)
}

protocol BaseDailyBriefDetailsPresenterInterface {
    func setupView()
    func reloadTableView()
}

protocol BaseDailyBriefDetailsInteractorInterface: Interactor {
    func getModel() -> BaseDailyBriefViewModel
    func updateModel(_ model: BaseDailyBriefViewModel)
    func getNumberOfRows() -> Int
    func getDetailsTableViewCell(for indexPath: IndexPath, owner: BaseDailyBriefDetailsViewController) -> UITableViewCell
    func customizeSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
    func saveAnswerValue(_ value: Int)
    func saveTargetValue(value: Int?)
}

protocol BaseDailyBriefDetailsRouterInterface: BaseRouterInterface {
    func showMyDataScreen()
    func presentCustomizeTarget(_ data: RatingQuestionViewModel.Question?)
    func showTBV()
    func presentMindsetResults(for mindsetShifter: QDMMindsetShifter?)
    func presentPrepareResults(for preparation: QDMUserPreparation?)
    func showTeamTBV(_ team: QDMTeam)
}
