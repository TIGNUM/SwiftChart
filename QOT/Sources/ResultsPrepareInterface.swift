//
//  ResultsPrepareInterface.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol ResultsPrepareViewControllerInterface: class {
    func setupView()
    func updateView(items: [Int: ResultsPrepare.Sections])
    func openEditStrategyView()
    func reloadData()
    func setupBarButtonItems(resultType: ResultType)
    func didUpdateIntentions(_ answerIds: [Int])
    func didUpdateBenefits(_ benefits: String)
}

protocol ResultsPreparePresenterInterface {
    func setupView()
    func createListItems(preparation: QDMUserPreparation?)
}

protocol ResultsPrepareInteractorInterface: Interactor {
    var sectionCount: Int { get }
    func rowCount(in section: Int) -> Int
    func hideEditIcon(title: String) -> Bool
    func getDTViewModel(key: Prepare.Key, _ completion: @escaping (DTViewModel, QDMQuestion?) -> Void)
    func updateBenefits(_ benefits: String)
    func updateIntentions(_ answerIds: [Int])
}

protocol ResultsPrepareRouterInterface {
    func dismiss()
    func presentContent(_ contentId: Int)
    func presentDTEditView(_ viewModel: DTViewModel, question: QDMQuestion?)
}
