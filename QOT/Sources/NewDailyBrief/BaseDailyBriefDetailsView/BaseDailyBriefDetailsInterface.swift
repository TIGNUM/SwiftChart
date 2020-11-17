//
//  BaseDailyBriefDetailsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol BaseDailyBriefDetailsViewControllerInterface: class {
    func setupView()
    func showAlert(message: String?)
    func presentMyDataScreen()
    func showCustomizeTarget()
}

protocol BaseDailyBriefDetailsPresenterInterface {
    func setupView()
}

protocol BaseDailyBriefDetailsInteractorInterface: Interactor {
    func getModel() -> BaseDailyBriefViewModel
    func getNumberOfRows() -> Int
    func getDetailsTableViewCell(for indexPath: IndexPath, owner: BaseDailyBriefDetailsViewController) -> UITableViewCell
    func customizeSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
}

protocol BaseDailyBriefDetailsRouterInterface {
    func dismiss()
    func showMyDataScreen()
    func presentCustomizeTarget(_ data: RatingQuestionViewModel.Question?)
}
