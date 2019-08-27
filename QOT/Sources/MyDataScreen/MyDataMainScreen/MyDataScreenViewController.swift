//
//  MyDataScreenViewController.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit
import JTAppleCalendar

enum MyDataRowType: Int, CaseIterable {
    case dailyImpactInfo = 0
    case dailyImpactChart
    case dailyImpactChartLegend
    case heatMapInfo
    case heatMapButtons
    case heatMap
}

final class MyDataScreenViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyDataScreenInteractorInterface?
    var router: MyDataScreenRouterInterface?
    @IBOutlet private weak var tableView: UITableView!
    private var myDataScreenModel: MyDataScreenModel?
    private var firstDayOfVisibleMonth: Date = Date().firstDayOfMonth() {
        didSet {
             self.requestNewResults()
        }
    }
    private lazy var heatMapDetailView = R.nib.myDataHeatMapDetailView.firstView(owner: self)
    private var lastDayOfVisibleMonth: Date = Date().lastDayOfMonth()
    private var impactReadinessResultsDict: [Date: MyDataDailyCheckInModel] = [:] {
        didSet {
            guard let cell = getHeatMapCell() else { return }
            cell.reloadCalendarData()
        }
    }
    let calendarPanGestureRecognizer = UIPanGestureRecognizer.init(target: self,
                                                                   action: #selector(didPanOrLongPressCalendarView(gesture:)))

    // MARK: - Init
    init(configure: Configurator<MyDataScreenViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = MyDataScreenConfigurator.make()
        configurator(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        firstDayOfVisibleMonth = Date().firstDayOfMonth()
        initialSetupForHeatMapDetailView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let myDataSelectionViewController  = segue.destination as? MyDataSelectionViewController else {
            return
        }
        myDataSelectionViewController.delegate = self
    }
}

// MARK: - Private
private extension MyDataScreenViewController {
    func setupTableView() {
        tableView.registerDequeueable(MyDataInfoTableViewCell.self)
        tableView.registerDequeueable(MyDataCharTableViewCell.self)
        tableView.registerDequeueable(MyDataChartLegendTableViewCell.self)
        tableView.registerDequeueable(MyDataHeatMapButtonsTableViewCell.self)
        tableView.registerDequeueable(MyDataHeatMapTableViewCell.self)
    }
}

// MARK: - Actions
private extension MyDataScreenViewController {
    @objc func didTapDetailView() {
        guard let heatMapCell = getHeatMapCell() else { return }
        heatMapCell.calendarView.deselectAllDates()
    }

    @objc func didPanOrLongPressCalendarView(gesture: UIGestureRecognizer) {
        guard let heatMapCell = getHeatMapCell() else { return }
        let calendarView = heatMapCell.calendarView
        let longPressPoint = gesture.location(in: calendarView)
        if let indexPath = calendarView?.indexPathForItem(at: longPressPoint),
           let dateCell = calendarView?.cellForItem(at: indexPath) as? MyDataHeatMapDateCell,
           calendarView?.selectedDates.first != dateCell.date {
            heatMapCell.calendarView.selectDates([dateCell.date], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
        }

    }
}

// MARK: - MyDataScreenViewControllerInterface
extension MyDataScreenViewController: MyDataScreenViewControllerInterface {
    func setupView() {
        setupTableView()
    }

    func setup(for myDataSection: MyDataScreenModel) {
        myDataScreenModel = myDataSection
    }
}

extension MyDataScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDataRowType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case MyDataRowType.dailyImpactInfo.rawValue:
            let dailyImpactInfoCell: MyDataInfoTableViewCell = tableView.dequeueCell(for: indexPath)
            dailyImpactInfoCell.configure(title: myDataScreenModel?.myDataItems[MyDataSection.dailyImpact.rawValue].title, subtitle: myDataScreenModel?.myDataItems[MyDataSection.dailyImpact.rawValue].subtitle)
            dailyImpactInfoCell.delegate = self

            return dailyImpactInfoCell
        case MyDataRowType.dailyImpactChart.rawValue:
            let dailyImpactCell: MyDataCharTableViewCell = tableView.dequeueCell(for: indexPath)

            return dailyImpactCell
        case MyDataRowType.dailyImpactChartLegend.rawValue:
            let chartLegendCell: MyDataChartLegendTableViewCell = tableView.dequeueCell(for: indexPath)
            chartLegendCell.configure(selectionModel: interactor?.myDataSelectionSections())
            chartLegendCell.delegate = self

            return chartLegendCell
        case MyDataRowType.heatMapInfo.rawValue:
            let heatMapInfoCell: MyDataInfoTableViewCell = tableView.dequeueCell(for: indexPath)
            heatMapInfoCell.configure(title: myDataScreenModel?.myDataItems[MyDataSection.heatMap.rawValue].title, subtitle: myDataScreenModel?.myDataItems[MyDataSection.heatMap.rawValue].subtitle)
            heatMapInfoCell.delegate = self

            return heatMapInfoCell
        case MyDataRowType.heatMapButtons.rawValue:
            let heatMapButtonsCell: MyDataHeatMapButtonsTableViewCell = tableView.dequeueCell(for: indexPath)
            heatMapButtonsCell.delegate = self

            return heatMapButtonsCell
        case MyDataRowType.heatMap.rawValue:
            let heatMapCell: MyDataHeatMapTableViewCell = tableView.dequeueCell(for: indexPath)
            let longTapRecognizer = UILongPressGestureRecognizer.init(target: self,
                                                                      action: #selector(didPanOrLongPressCalendarView(gesture:)))
            longTapRecognizer.minimumPressDuration = 0.25
            heatMapCell.calendarView.addGestureRecognizer(longTapRecognizer)

            heatMapCell.setCalendarDelegate(self)
            heatMapCell.setCalendarDatasource(self)

            return heatMapCell
        default:
            return UITableViewCell.init()
        }
    }
}

extension MyDataScreenViewController: MyDataInfoTableViewCellDelegate, MyDataChartLegendTableViewCellDelegate, MyDataHeatMapButtonsTableViewCellDelegate {
    func didTapAddButton() {
        router?.presentMyDataSelection()
    }

    func didChangeSelection(toMode: HeatMapMode) {
        myDataScreenModel?.selectedHeatMapMode = toMode
        guard let heatMapCell = getHeatMapCell() else { return }
        heatMapCell.reloadCalendarData()
    }

    func didTapInfoButton() {
        router?.presentMyDataExplanation()
    }
}

extension MyDataScreenViewController: MyDataSelectionViewControllerDelegate {
    func didChangeSelected(options: [MyDataSelectionModel.SelectionItem]) {
        if let sections = interactor?.initialDataSelectionSections().myDataSelectionItems, sections != options {
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: MyDataRowType.dailyImpactChart.rawValue, section: 0),
                                  at: .middle,
                                  animated: false)
        }
    }
}

extension MyDataScreenViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date().dateAfterYears(-1)
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

extension MyDataScreenViewController: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        if let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: MyDataHeatMapTableViewCell.dateCellIdentifier, for: indexPath) as? MyDataHeatMapDateCell {
            self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
            return cell
        }
        return JTAppleCell.init()
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        if let cell = cell as? MyDataHeatMapDateCell {
            configureCell(view: cell, cellState: cellState, date: date)
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let firstDay = JTAppleCalendarView.correctedCalendarDateFor(date: visibleDates.monthDates.first?.date ?? Date())
        let lastDay = JTAppleCalendarView.correctedCalendarDateFor(date: visibleDates.monthDates.last?.date ?? Date())
        if let heatMapCell = getHeatMapCell() {
            heatMapCell.setMonthAndYear(text: DateFormatter.MMMyyyy.string(from: lastDay))
            heatMapCell.showTodaysWeekdayLabel(asHighlighted: Date().isBetween(date: firstDay, andDate: lastDay))
        }
        if firstDay != firstDayOfVisibleMonth {
            firstDayOfVisibleMonth = firstDay
        }
        if lastDay != lastDayOfVisibleMonth {
            lastDayOfVisibleMonth = lastDay
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let dailySelected = myDataScreenModel?.selectedHeatMapMode == .dailyIR
        if let result = impactReadinessResultsDict[cellState.date],
           let impactReadiness = dailySelected ? result.impactReadiness : result.fiveDayImpactReadiness,
           let cell = cell as? MyDataHeatMapDateCell,
           cellState.dateBelongsTo == .thisMonth {
            showImpactReadinessView(calendar: calendar, withValue: impactReadiness, forCellState: cellState, forCell: cell)
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let cell = cell as? MyDataHeatMapDateCell,
            cellState.dateBelongsTo == .thisMonth {
            hideImpactReadinessView(calendar: calendar, forCell: cell)
        }
    }
}

extension MyDataScreenViewController: UICollectionViewDelegate {

}

// MARK: Helpers
extension MyDataScreenViewController {

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

        let dailySelected = myDataScreenModel?.selectedHeatMapMode == .dailyIR

        guard let result = impactReadinessResultsDict[cellState.date] else {
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

    func requestNewResults() {
        interactor?.getDailyResults(around: firstDayOfVisibleMonth, withMonthsBefore: 1, monthsAfter: 1, { [weak self] (resultsDict, error) in
            guard let dict = resultsDict, let s = self else {
                return
            }
            s.impactReadinessResultsDict = dict
        })
    }

    func showImpactReadinessView(calendar: JTAppleCalendarView, withValue: Double, forCellState: CellState, forCell: MyDataHeatMapDateCell) {
        guard let detailView = heatMapDetailView else {
            return
        }
        calendar.addSubview(detailView)
        calendar.bringSubview(toFront: detailView)
        createConstraintsForDetailsView(calendar: calendar, cellState: forCellState, cell: forCell)
        calendar.addGestureRecognizer(calendarPanGestureRecognizer)
        addGestureRecognizerOnDetailView()
        calendar.isScrollEnabled = false
        detailView.setValue(withValue, forDate: forCellState.date)
    }

    func hideImpactReadinessView(calendar: JTAppleCalendarView, forCell: MyDataHeatMapDateCell) {
        guard let detailView = heatMapDetailView else {
            return
        }
        calendar.isScrollEnabled = true
        calendar.removeGestureRecognizer(calendarPanGestureRecognizer)
        detailView.removeFromSuperview()
    }

    func createConstraintsForDetailsView(calendar: JTAppleCalendarView, cellState: CellState, cell: MyDataHeatMapDateCell) {
        guard let detailView = heatMapDetailView else {
            return
        }
        let centerConstraint = NSLayoutConstraint(item: detailView,
                                                  attribute: NSLayoutConstraint.Attribute.centerX,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: cell,
                                                  attribute: NSLayoutConstraint.Attribute.centerX,
                                                  multiplier: 1,
                                                  constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: detailView,
                                                  attribute: NSLayoutConstraint.Attribute.leading,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: cell,
                                                  attribute: NSLayoutConstraint.Attribute.leading,
                                                  multiplier: 1,
                                                  constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: detailView,
                                                   attribute: NSLayoutConstraint.Attribute.trailing,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: cell,
                                                   attribute: NSLayoutConstraint.Attribute.trailing,
                                                   multiplier: 1,
                                                   constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: detailView,
                                                  attribute: NSLayoutConstraint.Attribute.bottom,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: cell,
                                                  attribute: NSLayoutConstraint.Attribute.bottom,
                                                  multiplier: 1,
                                                  constant: 0)
        let heightConstraint = NSLayoutConstraint(item: detailView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: cell,
                                                  attribute: .height,
                                                  multiplier: 3,
                                                  constant: 0)
        let widthConstraint = NSLayoutConstraint(item: detailView,
                                                  attribute: .width,
                                                  relatedBy: .equal,
                                                  toItem: cell,
                                                  attribute: .width,
                                                  multiplier: 3,
                                                  constant: 0)
            switch cellState.column() {
            case 0:
                calendar.addConstraints([leadingConstraint, bottomConstraint, heightConstraint, widthConstraint])
            case 6:
                calendar.addConstraints([trailingConstraint, bottomConstraint, heightConstraint, widthConstraint])
            default:
                calendar.addConstraints([centerConstraint, bottomConstraint, heightConstraint, widthConstraint])
            }
    }

    func addGestureRecognizerOnDetailView() {
        if heatMapDetailView?.gestureRecognizers == nil {
            let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapDetailView))
            heatMapDetailView?.addGestureRecognizer(tapRecognizer)
        }
    }

    func initialSetupForHeatMapDetailView() {
        heatMapDetailView?.translatesAutoresizingMaskIntoConstraints = false
        heatMapDetailView?.alpha = 0.0
    }

    func getHeatMapCell() -> MyDataHeatMapTableViewCell? {
        guard let cell = tableView.cellForRow(at: IndexPath(row: MyDataRowType.heatMap.rawValue, section: 0)) as? MyDataHeatMapTableViewCell else { return nil }
        return cell
    }
}

extension JTAppleCalendarView {
    static func correctedCalendarDateFor(date: Date) -> Date {
        return date.dateAfterSeconds(Calendar.current.timeZone.secondsFromGMT())
    }
}
