//
//  SolveReminderTableCellViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 28.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SolveReminderTableCellViewModel: BaseDailyBriefViewModel {

    // MARK: Properties
    var title: String?
    var date: String?
    var solve: QDMSolve?

    // MARK: - Init
    internal init(title: String?, date: String?, solve: QDMSolve?, domainModel: QDMDailyBriefBucket) {
        self.title = title
        self.date = date
        self.solve = solve
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? SolveReminderTableCellViewModel else { return false }
        return super.isContentEqual(to: source) &&
            title == source.title &&
            date == source.date
    }

}
