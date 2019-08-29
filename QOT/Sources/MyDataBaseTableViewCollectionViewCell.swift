//
//  MyDataBaseTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 24/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class MyDataBaseTableViewCollectionViewCell: MyDataBaseTableViewCell {
    @IBOutlet private weak var monthYearLabel: UILabel!
    @IBOutlet private var weekDaysLabelsCollection: [UILabel]!

    // MARK: - Public

    public func setMonthAndYear(text: String) {
        self.monthYearLabel.text = text
    }

    public func showTodaysWeekdayLabel(asHighlighted: Bool) {
        if asHighlighted {
            let weekday = (Calendar.current.component(.weekday, from: Date()) - (Calendar.current.firstWeekday - 1))
            for label in self.weekDaysLabelsCollection {
                self.setupLabel(label, asHighlighted: label.tag == (weekday - 1))
            }
        } else {
            for label in self.weekDaysLabelsCollection {
                self.setupLabel(label, asHighlighted: false)
            }
        }
    }

    func populateWeekdaysLabels(_ forStartOfWeekDate: Date? = nil) {
        var daysOfTheWeekSymbols: [String] = []
        for index in 1...7 {
            var displayString = Date.weekdayNameFrom(weekdayNumber: index, short: true)
            if let date = forStartOfWeekDate {
                let displayDate = date.dateAfterDays(index - 1)
                displayString = DateFormatter.dd.string(from: displayDate) + "\n" + Date.weekdayNameFrom(weekdayNumber: index, short: true)
            }
            daysOfTheWeekSymbols.append(displayString)
        }
        for label in self.weekDaysLabelsCollection where daysOfTheWeekSymbols.count > label.tag {
            label.text = daysOfTheWeekSymbols[label.tag]
        }
    }

    // MARK: - Private

    internal func setupLabel(_ label: UILabel, asHighlighted: Bool) {
        if asHighlighted {
            label.font = .sfProtextSemibold(ofSize: 14)
            label.textColor = .sand
        } else {
            label.font = .sfProtextLight(ofSize: 14)
            label.textColor = .sand70
        }
    }
}
