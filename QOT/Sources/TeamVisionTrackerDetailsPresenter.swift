//
//  TeamVisionTrackerDetailsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamVisionTrackerDetailsPresenter {

    // MARK: - Properties
    private weak var viewController: TeamVisionTrackerDetailsViewControllerInterface?

    // MARK: - Init
    init(viewController: TeamVisionTrackerDetailsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - TeamVisionTrackerDetailsInterface
extension TeamVisionTrackerDetailsPresenter: TeamVisionTrackerDetailsPresenterInterface {
    func setupView(report: ToBeVisionReport) {
        viewController?.setupView()
        setupDates(report: report)
    }
}

// MARK: - Private
private extension TeamVisionTrackerDetailsPresenter {
    func setupDates(report: ToBeVisionReport) {
        let dates = report.report.dates
        var firstDateString: String?
        var secondDateString: String?
        var thirdDateString: String?

        if let firstDate = dates.first {
            firstDateString = DateFormatter.whatsHot.string(from: firstDate)
        }

        if let secondDate = dates.at(index: 1) {
            secondDateString = DateFormatter.whatsHot.string(from: secondDate)
        }

        if let thirdDate = dates.at(index: 2) {
            thirdDateString = DateFormatter.whatsHot.string(from: thirdDate)
        }

        viewController?.setupDates(firstDate: firstDateString,
                                   secondDate: secondDateString,
                                   thirdDate: thirdDateString)
    }
}
