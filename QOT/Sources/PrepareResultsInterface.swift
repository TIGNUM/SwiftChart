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
    var getType: QDMUserPreparation.Level { get }
    var getResultType: ResultType { get }
    var sectionCount: Int { get }
    func rowCount(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> PrepareResultsType?

    func presentRelatedArticle(readMoreID: Int)
    func presentEditStrategyView()
    func presentEditIntentions(_ key: Prepare.Key)
    func presentEditBenefits(benefits: String?)
    func presentMyPreps()

    func updateStrategies(selectedIds: [Int])
    func updateIntentions(_ answersIds: [Int])
    func updateBenefits(_ benefits: String)

    func didClickSaveAndContinue()
    func didTapDismissView()
    func deletePreparation()
    func updatePreparation(_ completion: @escaping (QDMUserPreparation?) -> Void)

    func presentCalendarPermission(_ permissionType: AskPermission.Kind)
    func checkSyncedCalendars()
}

protocol PrepareResultsRouterInterface: BaseRouterInterface {
    func didClickSaveAndContinue()
    func presentEditStrategyView(_ relatedStrategyId: Int, _ selectedIDs: [Int])
    func presentEditIntentions(_ viewModel: DTViewModel, question: QDMQuestion?)
    func presentEditBenefits(benefits: String?, questionID: Int)
    func presentMyPreps()
    func presentCalendarPermission(_ permissionType: AskPermission.Kind, delegate: AskPermissionDelegate)
    func presentCalendarSettings(delegate: SyncedCalendarsDelegate)
    func presentCalendarEventSelection()
}
