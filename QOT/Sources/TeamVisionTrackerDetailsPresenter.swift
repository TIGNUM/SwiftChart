//
//  TeamVisionTrackerDetailsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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
    func setupView(report: ToBeVisionReport, sentence: QDMToBeVisionSentence, selectedDate: Date) {
        viewController?.setupView()
        setupDates(dates: report.report.dates, selectedDate: selectedDate)
        setupSentence(sentence.text)
    }
}

// MARK: - Private
private extension TeamVisionTrackerDetailsPresenter {
    func setupDates(dates: [Date], selectedDate: Date) {
        var firstDateString: String?
        var secondDateString: String?
        var thirdDateString: String?
        let selectedIndex = indexOf(dates, selectedDate: selectedDate)

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
                                   thirdDate: thirdDateString,
                                   selectedIndex: selectedIndex)
    }

    func setupSentence(_ sentence: String) {
        viewController?.setupSentence(sentence)
    }

    func indexOf(_ dates: [Date], selectedDate: Date) -> Int {
        return dates.firstIndex(where: { $0 == selectedDate }) ?? 0
    }
}
