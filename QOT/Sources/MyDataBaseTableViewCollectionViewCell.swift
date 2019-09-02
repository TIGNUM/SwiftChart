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

    func setMonthAndYear(text: String) {
        ThemeText.myDataMonthYearTitle.apply(text, to: monthYearLabel)
    }

    func showTodaysWeekdayLabel(asHighlighted: Bool, centered: Bool = false) {
        let weekday = Date().weekdayNumberOrdinal()
        for label in self.weekDaysLabelsCollection {
            let labelTitle = label.attributedText?.string
            if label.tag == (weekday - 1) && asHighlighted {
                ThemeText.myDataWeekdaysHighlighted(centered).apply(labelTitle, to: label)
            } else {
                ThemeText.myDataWeekdaysNotHighlighted(centered).apply(labelTitle, to: label)
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
}
