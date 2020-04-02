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
    func didUpdateIntentions(_ answerIds: [Int])
    func didUpdateBenefits(_ benefits: String)
}

protocol ResultsPreparePresenterInterface {
    func setupView()
    func createListItems(preparation: QDMUserPreparation?)
}

protocol ResultsPrepareInteractorInterface: Interactor {
    var getType: String { get }
    var sectionCount: Int { get }
    func rowCount(in section: Int) -> Int
    func hideEditIcon(title: String) -> Bool

    func getDTViewModel(key: Prepare.Key, _ completion: @escaping (DTViewModel, QDMQuestion?) -> Void)
    func getStrategyIds() -> (relatedId: Int, selectedIds: [Int], selectedItemIds: [Int])

    func updateBenefits(_ benefits: String)
    func updateIntentions(_ answerIds: [Int])
    func updateStrategies(_ selectedIds: [Int], selectedItemIds: [Int])
    func updatePreparationEvent(event: QDMUserCalendarEvent?)
    func removePreparationCalendarEvent()
    func updatePreparation(_ completion: @escaping (QDMUserPreparation?) -> Void)
    func deletePreparation()

    func didClickSaveAndContinue()
}

protocol ResultsPrepareRouterInterface {
    func presentPlans()
    func presentDTEditView(_ viewModel: DTViewModel,
                           question: QDMQuestion?,
                           delegate: ResultsPrepareViewControllerInterface?)
    func presentEditStrategyView(_ relatedStrategyId: Int,
                                 _ selectedIDs: [Int],
                                 _ selectedItemIds: [Int],
                                 delegate: ChoiceViewControllerDelegate?)
    func presentCalendarEventSelection()
    func didSelectConnectToCalendar()
    func didSelectStrategy(_ contentId: Int)
    func didSelectStrategyItem(_ contentItemId: Int)
    func didTapDismiss()
}
