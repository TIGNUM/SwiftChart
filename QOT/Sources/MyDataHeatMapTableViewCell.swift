//
//  MyDataHeatMapTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import JTAppleCalendar

final class MyDataHeatMapTableViewCell: MyDataBaseTableViewCollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var calendarView: JTAppleCalendarView!
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

    func reloadCalendarData() {
        self.calendarView.reloadData()
    }

    // MARK: - Private

    // MARK: Helpers
    func setupCalendarView() {
        let startDateForCalendar = Date()
        //general setup of CalendarView
        self.calendarView.registerDequeueable(MyDataHeatMapDateCell.self)
        self.calendarView.scrollDirection = .horizontal
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        self.calendarView.showsHorizontalScrollIndicator = false
        self.calendarView.clipsToBounds = false

        //setup CalendarView for currentDate
        self.populateWeekdaysLabels()
        self.setMonthAndYear(text: DateFormatter.MMMyyyy.string(from: startDateForCalendar))
        showTodaysWeekdayLabel(asHighlighted: true)
    }
}

extension JTAppleCalendarView {
    static func correctedCalendarDateFor(date: Date) -> Date {
        return date.dateAfterSeconds(Calendar.current.timeZone.secondsFromGMT())
    }
}
