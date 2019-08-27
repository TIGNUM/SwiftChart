//
//  MyDataScreenInterface.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol MyDataScreenViewControllerInterface: class {
    func setupView()
    func setup(for myDataSection: MyDataScreenModel)
}

protocol MyDataScreenPresenterInterface {
    func setupView()
    func present(for myDataSection: MyDataScreenModel)
}

protocol MyDataScreenInteractorInterface: Interactor {
    func presentMyDataExplanation()
    func presentMyDataSelection()
    func myDataSelectionSections() -> MyDataSelectionModel
    func initialDataSelectionSections() -> MyDataSelectionModel
    func getDailyResults(around date: Date,
                         withMonthsBefore: Int,
                         monthsAfter: Int,
                         _ completion: @escaping([Date: MyDataDailyCheckInModel]?, Error?) -> Void)
}

protocol MyDataScreenRouterInterface {
    func presentMyDataExplanation()
    func presentMyDataSelection()
    func dismiss()
}

protocol MyDataWorkerInterface {
    func myDataSections() -> MyDataScreenModel
    func myDataSelectionSections() -> MyDataSelectionModel
    func getDailyResults(around date: Date,
                         withMonthsBefore: Int,
                         monthsAfter: Int,
                         _ completion: @escaping([Date: MyDataDailyCheckInModel]?, Error?) -> Void)
}
