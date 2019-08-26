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

    func didChangeSelection(to: HeatMapMode) {
        //update heat map
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

    // MRAK: Helpers

    func configureCell(view: JTAppleCell?, cellState: CellState, date: Date) {
        guard let cell = view as? MyDataHeatMapDateCell  else { return }
        cell.dateLabel.text = cellState.text
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
    }

    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let firstDay = JTAppleCalendarView.correctedCalendarDateFor(date: visibleDates.monthDates.first?.date ?? Date())
        let lastDay = JTAppleCalendarView.correctedCalendarDateFor(date: visibleDates.monthDates.last?.date ?? Date())
        if let heatMapCell = tableView.cellForRow(at: IndexPath(row: MyDataRowType.heatMap.rawValue, section: 0)) as? MyDataHeatMapTableViewCell {
            heatMapCell.setMonthAndYear(text: DateFormatter.MMMyyyy.string(from: lastDay))
            heatMapCell.showTodaysWeekdayLabel(asHighlighted: Date().isBetween(date: firstDay, andDate: lastDay))
        }
    }
}

extension JTAppleCalendarView {
    static func correctedCalendarDateFor(date: Date) -> Date {
        return date.dateAfterSeconds(Calendar.current.timeZone.secondsFromGMT())
    }
}
