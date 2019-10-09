//
//  SolveDayPlanTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SolveDayPlanTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var fiveDayPlanTextLabel: UILabel!
    @IBOutlet private weak var hasHeaderTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var hasNoHeaderTopConstraint: NSLayoutConstraint?
}

// MARK: - Configuration

extension SolveDayPlanTableViewCell {

    func configure(hasHeader: Bool, with text: String) {
        selectionStyle = .none
        ThemeText.resultList.apply(AppTextService.get(AppTextKey.coach_solve_results_view_solution_title), to: headerLabel)
        ThemeText.resultHeader2.apply(text, to: fiveDayPlanTextLabel)

        hasHeaderTopConstraint?.isActive = hasHeader == true
        hasNoHeaderTopConstraint?.isActive = hasHeader == false
        headerLabel.isHidden = hasHeader == false
    }
}
