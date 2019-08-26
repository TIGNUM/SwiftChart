//
//  MyDataHeatMapTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol MyDataHeatMapTableViewCellDelegate: class {

}

final class MyDataHeatMapTableViewCell: MyDataBaseTableViewCell {
    static let dateCellIdentifier = "dateCell"
    // MARK: - Properties
    weak var delegate: MyDataHeatMapTableViewCellDelegate?
    @IBOutlet private weak var calendarView: JTAppleCalendarView!
    @IBOutlet private weak var monthYearLabel: UILabel!
    @IBOutlet private var weekDaysLabelsCollection: [UILabel]!
    @IBOutlet private weak var topColorView: UIView!
    @IBOutlet private weak var bottomColorView: UIView!
    @IBOutlet private weak var topColorLabel: UILabel!
    @IBOutlet private weak var bottomColorLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCalendarView()
    }

    // MARK: - Public
    func setCalendarDatasource(_ datasource: JTAppleCalendarViewDataSource) {
        self.calendarView.calendarDataSource = datasource
    }

    func setCalendarDelegate(_ delegate: JTAppleCalendarViewDelegate) {
        self.calendarView.calendarDelegate = delegate
    }

    func setMonthAndYear(text: String) {
        self.monthYearLabel.text = text
    }

    func reloadCalendarData() {
        self.calendarView.reloadData()
    }

    // MARK: - Private

    // MARK: Helpers
    func setupCalendarView() {
        //general setup of CalendarView
        self.calendarView.register(R.nib.myDataHeatMapDateCell)
        self.calendarView.scrollDirection = .horizontal
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        self.calendarView.showsHorizontalScrollIndicator = false

        //setup CalendarView for currentDate
        let today = Date()
        self.populateWeekdaysLables()
        self.calendarView.scrollToDate(today)
        self.setMonthAndYear(text: DateFormatter.MMMyyyy.string(from: today))
        showTodaysWeekdayLabel(asHighlighted: true)
    }

    private func populateWeekdaysLables() {
        var daysOfTheWeekSymbols: [String] = []
        for index in 1...7 {
            daysOfTheWeekSymbols.append(Date.weekdayNameFrom(weekdayNumber: index, short: true))
        }
        for label in self.weekDaysLabelsCollection where daysOfTheWeekSymbols.count > label.tag {
            label.text = daysOfTheWeekSymbols[label.tag]
        }
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

    func setupLabel(_ label: UILabel, asHighlighted: Bool) {
        if asHighlighted {
            label.font = .sfProtextSemibold(ofSize: 14)
            label.textColor = .sand
        } else {
            label.font = .sfProtextLight(ofSize: 14)
            label.textColor = .sand70
        }
    }
}
