//
//  PrepareResultsInterface.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol PrepareResultsViewControllerInterface: class {
    func setupView()
    func registerTableViewCell(_ type: QDMUserPreparation.Level)
    func reloadView()
}

protocol PrepareResultsPresenterInterface {
    func setupView()
    func registerTableViewCell(_ type: QDMUserPreparation.Level)
    func reloadView()
}

protocol PrepareResultsInteractorInterface: Interactor {
    var saveToICal: Bool { get set }
    var setReminder: Bool { get set }
    var getType: QDMUserPreparation.Level { get }
    var sectionCount: Int { get }
    func rowCount(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> PrepareResultsType?
    func presentRelatedArticle(readMoreID: Int)
    func didClickSaveAndContinue()
    func deletePreparationIfNeeded()
    func presentEditStrategyView()
    func presentEditIntentions(_ key: Prepare.Key)
    func presentEditBenefits(benefits: String?, questionID: Int)
    func updateStrategies(selectedIds: [Int])
    func updateIntentions(_ answers: [DecisionTreeModel.SelectedAnswer], _ key: Prepare.Key)
    func updateBenefits(_ benefits: String)
}

protocol PrepareResultsRouterInterface {
    func presentRelatedArticle(readMoreID: Int)
    func didClickSaveAndContinue()
    func presentEditStrategyView(_ relatedStrategyId: Int, _ selectedIDs: [Int])
    func presentEditIntentions(_ selectedAnswers: [DecisionTreeModel.SelectedAnswer], _ key: Prepare.Key, answerFilter: String?)
    func presentEditBenefits(benefits: String?, questionID: Int)
}
