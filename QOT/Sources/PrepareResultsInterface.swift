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
    func showAlert(title: String, message: String, cancelTitle: String, leaveTitle: String)
}

protocol PrepareResultsPresenterInterface {
    func setupView()
    func registerTableViewCell(_ type: QDMUserPreparation.Level)
    func reloadView()
    func presentAlert(title: String, message: String, cancelTitle: String, leaveTitle: String)
}

protocol PrepareResultsInteractorInterface: Interactor {    
    var setReminder: Bool { get set }
    var getType: QDMUserPreparation.Level { get }
    var dataModified: Bool { get }
    var sectionCount: Int { get }
    func rowCount(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> PrepareResultsType?
    func presentRelatedArticle(readMoreID: Int)
    func presentEditStrategyView()
    func presentEditIntentions(_ key: Prepare.Key)
    func presentEditBenefits(benefits: String?, questionID: Int)
    func updateStrategies(selectedIds: [Int])
    func updateIntentions(_ answersIds: [Int])
    func updateBenefits(_ benefits: String)
    func openConfirmationView()
    func didClickSaveAndContinue()
    func didTapLeaveWithoutSaving()
    func didTapDismissView()
}

protocol PrepareResultsRouterInterface {
    func presentRelatedArticle(readMoreID: Int)
    func didClickSaveAndContinue()
    func dismiss()
    func dismissChatBotFlow()
    func presentEditStrategyView(_ relatedStrategyId: Int, _ selectedIDs: [Int])
    func presentEditIntentions(_ viewModel: DTViewModel, question: QDMQuestion?)
    func presentEditBenefits(benefits: String?, questionID: Int)
}
