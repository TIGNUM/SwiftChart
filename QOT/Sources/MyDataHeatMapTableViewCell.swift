//
//  MyDataHeatMapTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import JTAppleCalendar
import qot_dal

final class MyDataHeatMapTableViewCell: MyDataBaseTableViewCollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet private weak var topColorView: UIView!
    @IBOutlet private weak var bottomColorView: UIView!
    @IBOutlet private weak var topColorLabel: UILabel!
    @IBOutlet private weak var bottomColorLabel: UILabel!
    @IBOutlet weak var leftMaskView: UIView?
    @IBOutlet weak var rightMaskView: UIView?
    override public var backgroundColor: UIColor? {
        didSet {
            self.leftMaskView?.backgroundColor = self.backgroundColor
            self.rightMaskView?.backgroundColor = self.backgroundColor
        }
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCalendarView()
        ThemeView.level2.apply(self)
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

    private func setupCalendarView() {
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
        ThemeText.myDataHeatMapLegendText.apply(ScreenTitleService.main.myDataHeatMapLegendHighTitle(), to: topColorLabel)
        ThemeText.myDataHeatMapLegendText.apply(ScreenTitleService.main.myDataHeatMapLegendLowTitle(), to: bottomColorLabel)
    }
}

extension JTAppleCalendarView {
    static func correctedCalendarDateFor(date: Date) -> Date {
        return date.dateAfterSeconds(Calendar.current.timeZone.secondsFromGMT())
    }
}
