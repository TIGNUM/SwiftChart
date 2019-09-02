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

final class MyDataScreenViewController: UIViewController, ScreenZLevel2 {

    // MARK: - Properties
    var interactor: MyDataScreenInteractorInterface?
    var router: MyDataScreenRouterInterface?
    private var myDataScreenModel: MyDataScreenModel?
    @IBOutlet private weak var tableView: UITableView!

    //HeatMap properties
    private lazy var heatMapDetailView = R.nib.myDataHeatMapDetailView.firstView(owner: self)
    private let calendarPanGestureRecognizer = UIPanGestureRecognizer.init(target: self,
                                                                   action: #selector(didPanOrLongPressCalendarView(gesture:)))
    //Graph helper views and constants
    private var chartSnapshot = UIImageView.init(frame: .zero)
    private var originalCenter: CGPoint?
    private var isZooming = false
    private let zoomBackAnimationDuration = 0.3
    private let maxZoomScale: CGFloat = 5.0
    private let minZoomScale: CGFloat = 1.0
    private let scaleStepForTableViewAlpha: CGFloat = 1.5

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
        initialSetupForHeatMapDetailView()
        showLoadingSkeleton(with: [.oneLineHeading, .myDataGraph, .twoLinesAndTag])
        setupZoomingGestureRecognizers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var type = MyDataSection.dailyImpact
        if let data = sender as? MyDataSection {
            type = data
        }
        router?.passDataToScene(segue: segue, withType: type)
    }
}

// MARK: - Private
private extension MyDataScreenViewController {

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
            let dailyImpactChartCell: MyDataChartTableViewCell = tableView.dequeueCell(for: indexPath)
            if let strongInteractor = interactor {
                dailyImpactChartCell.setGraphCollectionViewDelegate(strongInteractor)
                dailyImpactChartCell.setGraphCollectionViewDatasource(strongInteractor)
            }

            return dailyImpactChartCell
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

            if let strongInteractor = interactor {
                heatMapCell.setCalendarDelegate(strongInteractor)
                heatMapCell.setCalendarDatasource(strongInteractor)
                if interactor?.getFirstLoad() ?? false {
                    heatMapCell.calendarView.scrollToDate(Date())
                }
            }

            return heatMapCell
        default:
            return UITableViewCell.init()
        }
    }
}

extension MyDataScreenViewController: UIGestureRecognizerDelegate {

    // MARK: Pinch to zoom and pan functionality

    func setupZoomingGestureRecognizers() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender:)))
        pinch.delegate = self
        view.addGestureRecognizer(pinch)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        self.chartSnapshot.isUserInteractionEnabled = false
    }

    @objc func pinch(sender: UIPinchGestureRecognizer) {
        guard let chartCell = getChartCell() else {
            return
        }
        let location = sender.location(in: tableView)
        if tableView.indexPathForRow(at: location) != IndexPath(row: MyDataRowType.dailyImpactChart.rawValue, section: 0) ||
            !(interactor?.getVisibleGraphHasData() ?? false) {
            return
        }
        switch sender.state {
        case .began:
            chartSnapshot.image = chartCell.takeSnapshot()
            chartSnapshot.backgroundColor = ThemeView.level2.color
            chartSnapshot.frame = tableView.convert(chartCell.frame, to: view)
            view.addSubview(chartSnapshot)
            self.originalCenter = chartSnapshot.center
            isZooming = true
            setupInteractionFor(zooming: isZooming)
        case .changed:
            let currentScale = self.chartSnapshot.frame.size.width / self.chartSnapshot.bounds.size.width
            var newScale = currentScale * sender.scale
            if newScale < minZoomScale {
                newScale = minZoomScale
            }
            if newScale > maxZoomScale {
                newScale = maxZoomScale
            }
            tableView.alpha = scaleStepForTableViewAlpha - newScale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.chartSnapshot.transform = transform
            sender.scale = 1
        default:
            guard let center = self.originalCenter else { return }
            self.isZooming = false
            setupInteractionFor(zooming: isZooming)
            performZoomBackAnimation(forOriginalCenter: center)
        }
    }

    @objc func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalCenter = chartSnapshot.center
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: self.view)
                chartSnapshot.center = CGPoint(x: chartSnapshot.center.x + translation.x,
                                               y: chartSnapshot.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: chartSnapshot.superview)
        } else if self.isZooming && (sender.state == .ended || sender.state == .failed || sender.state == .cancelled) {
            guard let center = self.originalCenter else { return }
            self.isZooming = false
            setupInteractionFor(zooming: isZooming)
            performZoomBackAnimation(forOriginalCenter: center)
        }
    }

    // MARK: Gesture recognizer Delegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    // MARK: Gesture recognizer Helpers

    func performZoomBackAnimation(forOriginalCenter: CGPoint) {
        UIView.animate(withDuration: zoomBackAnimationDuration, animations: { [weak self] in
            self?.chartSnapshot.transform = CGAffineTransform.identity
            self?.chartSnapshot.center = forOriginalCenter
            self?.tableView.alpha = 1.0
            }, completion: { [weak self] _ in
                self?.chartSnapshot.removeFromSuperview()
        })
    }

    func setupInteractionFor(zooming: Bool) {
        tableView.isScrollEnabled = !zooming
        getChartCell()?.graphCollectionView.isScrollEnabled = !zooming
    }
}

extension MyDataScreenViewController: MyDataInfoTableViewCellDelegate, MyDataChartLegendTableViewCellDelegate, MyDataHeatMapButtonsTableViewCellDelegate {

    // MARK: Custom Delegates

    func didTapAddButton() {
        router?.presentMyDataSelection()
    }

    func didChangeSelection(toMode: HeatMapMode) {
        interactor?.setDailySelected(toMode)
        guard let heatMapCell = getHeatMapCell() else { return }
        heatMapCell.reloadCalendarData()
    }

    func didTapInfoButton(sender: MyDataInfoTableViewCell) {
        var type: MyDataSection = .heatMap
        if tableView.cellForRow(at: IndexPath(row: MyDataRowType.dailyImpactInfo.rawValue, section: 0)) == sender {
            type = .dailyImpact
        }
        router?.presentMyDataExplanation(withType: type)
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

// MARK: MyDataScreenViewControllerInterface
extension MyDataScreenViewController: MyDataScreenViewControllerInterface {
    func setupView() {
        setupTableView()
        ThemeView.level2.apply(view)
    }

    func setupTableView() {
        tableView.registerDequeueable(MyDataInfoTableViewCell.self)
        tableView.registerDequeueable(MyDataChartTableViewCell.self)
        tableView.registerDequeueable(MyDataChartLegendTableViewCell.self)
        tableView.registerDequeueable(MyDataHeatMapButtonsTableViewCell.self)
        tableView.registerDequeueable(MyDataHeatMapTableViewCell.self)
    }

    func setup(for myDataSection: MyDataScreenModel) {
        myDataScreenModel = myDataSection
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

    func updateHeaderDateLabel(forSection: MyDataSection, withFirstDay: Date, andLastDay: Date) {
        if forSection == .heatMap, let heatMapCell = getHeatMapCell() {
            heatMapCell.setMonthAndYear(text: DateFormatter.MMMyyyy.string(from: andLastDay))
            heatMapCell.showTodaysWeekdayLabel(asHighlighted: Date().isBetween(date: withFirstDay, andDate: andLastDay.endOfDay()), centered: true)
        } else if forSection == .dailyImpact, let graphCell = getChartCell() {
            let mideWeekDay = andLastDay.dateAfterDays(-3)
            graphCell.setMonthAndYear(text: DateFormatter.MMMyyyy.string(from: mideWeekDay))
            graphCell.populateWeekdaysLabels(withFirstDay)
            graphCell.showTodaysWeekdayLabel(asHighlighted: Date().isBetween(date: withFirstDay, andDate: andLastDay), centered: false)
        }
    }

    func dataSourceFinished(firstLoad: Bool) {
        removeLoadingSkeleton()
        if let heatMapCell = getHeatMapCell() {
            heatMapCell.reloadCalendarData()
            if firstLoad {
                heatMapCell.calendarView.scrollToDate(Date())
            }
        }
        if let chartCell = getChartCell() {
            chartCell.graphCollectionView.reloadData()
            if firstLoad {
                chartCell.graphCollectionView.scrollToItem(at: IndexPath(row: (interactor?.getFirstWeekdaysDatasource().count ?? 1) - 1,
                                                                         section: 0),
                                                           at: .right,
                                                           animated: false)
            }
        }
    }
}

// MARK: Helpers
extension MyDataScreenViewController {
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
        return tableView.cellForRow(at: IndexPath(row: MyDataRowType.heatMap.rawValue, section: 0)) as? MyDataHeatMapTableViewCell
    }

    func getChartCell() -> MyDataChartTableViewCell? {
        return tableView.cellForRow(at: IndexPath(row: MyDataRowType.dailyImpactChart.rawValue, section: 0)) as? MyDataChartTableViewCell
    }
}
