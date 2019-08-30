//
//  MyDataScreenInteractor.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit
import JTAppleCalendar

final class MyDataScreenInteractor: NSObject {

    // MARK: - Properties
    private let worker: MyDataScreenWorker
    private let presenter: MyDataScreenPresenterInterface
    private let router: MyDataScreenRouterInterface

    // MARK: - Init
    init(worker: MyDataScreenWorker, presenter: MyDataScreenPresenterInterface, router: MyDataScreenRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.present(for: worker.myDataSections())
        presenter.setupView()
        self.getDailyResults(around: worker.heatMapFirstDayOfVisibleMonth, withMonthsBefore: 1, monthsAfter: 1) { [weak self] (results, error) in
            guard let s = self else { return }
            s.presenter.dataSourceFinished(firstLoad: true)
        }
    }
}

// MARK: - MyDataScreenInteractorInterface
extension MyDataScreenInteractor: MyDataScreenInteractorInterface {
    func presentMyDataExplanation() {
        router.presentMyDataExplanation()
    }

    func presentMyDataSelection() {
        router.presentMyDataSelection()
    }

    func myDataSelectionSections() -> MyDataSelectionModel {
        return worker.myDataSelectionSections()
    }

    func initialDataSelectionSections() -> MyDataSelectionModel {
        return worker.initialDataSelectionSections
    }

    func setOldestAvailableDate(date: Date) {
        worker.oldestAvailableDate = date
    }

    func getDailyResults(around date: Date,
                         withMonthsBefore: Int,
                         monthsAfter: Int,
                         _ completion: @escaping([Date: MyDataDailyCheckInModel]?, Error?) -> Void) {
        worker.getDailyResults(around: date,
                               withMonthsBefore: withMonthsBefore,
                               monthsAfter: monthsAfter,
                               completion)
    }

    func setDailySelected(_ selectedMode: HeatMapMode) {
        worker.selectedHeatMapMode = selectedMode
    }

    func getDailySelected() -> HeatMapMode {
        return worker.selectedHeatMapMode
    }

    func getFirstWeekdaysDatasource() -> [Date] {
        return worker.graphFirstWeekdaysDatasource
    }

    func getVisibleGraphHasData() -> Bool {
        return worker.visibleGraphHasData
    }

    func getFirstLoad() -> Bool {
        return worker.firstLoad
    }
}

extension MyDataScreenInteractor: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = worker.oldestAvailableDate
        let endDate = Date()
        let config = ConfigurationParameters(startDate: startDate,
                                             endDate: endDate,
                                             numberOfRows: 6,
                                             generateInDates: .forAllMonths,
                                             generateOutDates: .tillEndOfRow,
                                             firstDayOfWeek: DaysOfWeek(rawValue: Calendar.current.firstWeekday) ?? .monday,
                                             hasStrictBoundaries: true)
        return config
    }
}

extension MyDataScreenInteractor: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell: MyDataHeatMapDateCell = calendar.dequeueCell(for: indexPath)
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        if let cell = cell as? MyDataHeatMapDateCell {
            configureCell(view: cell, cellState: cellState, date: date)
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let firstDay = JTAppleCalendarView.correctedCalendarDateFor(date: visibleDates.monthDates.first?.date ?? Date())
        let lastDay = JTAppleCalendarView.correctedCalendarDateFor(date: visibleDates.monthDates.last?.date ?? Date())
        presenter.updateHeaderDateLabel(forSection: .heatMap, withFirstDay: firstDay, andLastDay: lastDay)

        if firstDay != worker.heatMapFirstDayOfVisibleMonth {
            worker.heatMapFirstDayOfVisibleMonth = firstDay
            self.getDailyResults(around: firstDay, withMonthsBefore: 1, monthsAfter: 1) { [weak self] (results, error) in
                guard let s = self else { return }
                s.worker.firstLoad = false
                s.presenter.dataSourceFinished(firstLoad: s.worker.firstLoad)
            }
        }
        if lastDay != worker.heatMapLastDayOfVisibleMonth {
            worker.heatMapLastDayOfVisibleMonth = lastDay
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let dailySelected = getDailySelected() == .dailyIR
        if let result = worker.impactReadinessDatasource[cellState.date],
            let impactReadiness = dailySelected ? result.impactReadiness : result.fiveDayImpactReadiness,
            let cell = cell as? MyDataHeatMapDateCell,
            cellState.dateBelongsTo == .thisMonth {
            presenter.showImpactReadinessView(calendar: calendar, withValue: impactReadiness, forCellState: cellState, forCell: cell)
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let cell = cell as? MyDataHeatMapDateCell,
            cellState.dateBelongsTo == .thisMonth {
            presenter.hideImpactReadinessView(calendar: calendar, forCell: cell)
        }
    }

    func configureCell(view: JTAppleCell?, cellState: CellState, date: Date) {
        guard let cell = view as? MyDataHeatMapDateCell  else { return }
        cell.dateLabel.text = cellState.text
        cell.date = date
        handleCellVisibility(cell: cell, cellState: cellState)
    }

    func handleCellVisibility(cell: MyDataHeatMapDateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        if Date().isSameDay(JTAppleCalendarView.correctedCalendarDateFor(date: cellState.date)) {
            cell.dateLabel.font = .sfProtextSemibold(ofSize: 16)
            cell.dateLabel.textColor = .sand
        } else {
            cell.dateLabel.font = .sfProDisplayRegular(ofSize: 16)
            cell.dateLabel.textColor = .sand70
        }

        let dailySelected = getDailySelected() == .dailyIR

        guard let result = worker.impactReadinessDatasource[cellState.date] else {
            setNoDataUI(forCell: cell)
            return
        }

        if dailySelected {
            guard let impactReadiness = result.impactReadiness else {
                setNoDataUI(forCell: cell)
                return
            }
            cell.backgroundColor = MyDataScreenWorker.heatMapColor(forImpactReadiness: impactReadiness)
            cell.noDataImageView.isHidden = true
        } else {
            guard let fiveDaysRollingIR = result.fiveDayImpactReadiness else {
                setNoDataUI(forCell: cell)
                return
            }
            cell.backgroundColor = MyDataScreenWorker.heatMapColor(forImpactReadiness: fiveDaysRollingIR)
            cell.noDataImageView.isHidden = true
        }
    }

    func setNoDataUI(forCell: MyDataHeatMapDateCell) {
        forCell.backgroundColor = .clear
        forCell.noDataImageView.isHidden = false
    }
}

// MARK: Graph CollectionView Delegates & DataSource

extension MyDataScreenInteractor: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView,
           let visibleIndexPath = visibleIndexPath(for: collectionView) {
                updateGraphHeader(forIndexPath: visibleIndexPath)
                worker.visibleGraphHasData = modelsFor(indexPath: visibleIndexPath).count > 0
        }
    }

    func updateGraphHeader(forIndexPath: IndexPath) {
        let firstDay = worker.graphFirstWeekdaysDatasource[forIndexPath.row]
        let lastDay = firstDay.lastDayOfWeek()
        presenter.updateHeaderDateLabel(forSection: .dailyImpact, withFirstDay: firstDay, andLastDay: lastDay)
    }

    // MARK: Helpers

    func datesOfTheWeek(forIndexPath: IndexPath) -> [Date] {
        var dates: [Date] = []
        let firstDay = worker.graphFirstWeekdaysDatasource[forIndexPath.row]
        for dayIndex in 0...6 {
            dates.append(firstDay.dateAfterDays(dayIndex))
        }
        return dates
    }

    func modelsFor(indexPath: IndexPath) -> [Date: MyDataDailyCheckInModel] {
        var existingModelsForDisplayedDates: [Date: MyDataDailyCheckInModel] = [:]
        for date in datesOfTheWeek(forIndexPath: indexPath) {
            if let model = worker.impactReadinessDatasource[date] {
                existingModelsForDisplayedDates[date] = model
            }
        }
        return existingModelsForDisplayedDates
    }

    func visibleIndexPath(for collectionView: UICollectionView) -> IndexPath? {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)
    }
}

extension MyDataScreenInteractor: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyDataChartCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(withModels: modelsFor(indexPath: indexPath),
                       selectionModel: worker.myDataSelectionSections())
        if let visibleIndexPath = visibleIndexPath(for: collectionView),
           visibleIndexPath == indexPath {
            updateGraphHeader(forIndexPath: visibleIndexPath)
            worker.visibleGraphHasData = modelsFor(indexPath: visibleIndexPath).count > 0
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return worker.graphFirstWeekdaysDatasource.count
    }
}
