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

    @IBOutlet weak var calendarContentView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
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
        skeletonManager.addOtherView(calendarContentView)
        skeletonManager.addSubtitle(monthYearLabel)
    }

    // MARK: - Public
    func setCalendarDatasource(_ datasource: JTAppleCalendarViewDataSource) {
        self.calendarView.calendarDataSource = datasource
    }

    func setCalendarDelegate(_ delegate: JTAppleCalendarViewDelegate) {
        self.calendarView.calendarDelegate = delegate
    }

    func reloadCalendarData() {
        self.calendarView.deselectAllDates()
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
    }
}

extension JTAppleCalendarView {
    static func correctedCalendarDateFor(date: Date) -> Date {
        return date.dateAfterSeconds(Calendar.current.timeZone.secondsFromGMT())
    }

    //handle the touches outside of calendar view's bounds - because heatMapDetailView sometimes exceeds the calendar's bounds and we want to receive touches all over details view
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if clipsToBounds || isHidden || alpha == .zero {
            return nil
        }
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }
        return nil
    }
}
