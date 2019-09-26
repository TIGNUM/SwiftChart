//
//  MyDataScreenInterface.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import JTAppleCalendar

protocol MyDataScreenViewControllerInterface: class {
    func setupView()
    func setup(for myDataSection: MyDataScreenModel)
    func showImpactReadinessView(calendar: JTAppleCalendarView, withValue: Double, forCellState: CellState, forCell: MyDataHeatMapDateCell)
    func hideImpactReadinessView(calendar: JTAppleCalendarView, forCell: MyDataHeatMapDateCell)
    func updateHeaderDateLabel(forSection: MyDataSection, withFirstDay: Date, andLastDay: Date)
    func dataSourceFinished(firstLoad: Bool)
}

protocol MyDataScreenPresenterInterface {
    func setupView()
    func present(for myDataSection: MyDataScreenModel)
    func showImpactReadinessView(calendar: JTAppleCalendarView, withValue: Double, forCellState: CellState, forCell: MyDataHeatMapDateCell)
    func hideImpactReadinessView(calendar: JTAppleCalendarView, forCell: MyDataHeatMapDateCell)
    func updateHeaderDateLabel(forSection: MyDataSection, withFirstDay: Date, andLastDay: Date)
    func dataSourceFinished(firstLoad: Bool)
}

protocol MyDataScreenInteractorInterface: Interactor, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    func myDataSelectionSections() -> MyDataSelectionModel
    func initialDataSelectionSections() -> MyDataSelectionModel
    func setOldestAvailableDate(date: Date)
    func getFirstLoad() -> Bool
    func getDatasourceLoaded() -> Bool
    func getVisibleGraphHasData() -> Bool
    func getFirstWeekdaysDatasource() -> [Date]
    func getDailyResults(around date: Date,
                         withMonthsBefore: Int,
                         monthsAfter: Int,
                         _ completion: @escaping([Date: MyDataDailyCheckInModel]?, Error?) -> Void)
    func setDailySelected(_ selectedMode: HeatMapMode)
    func getDailySelected() -> HeatMapMode
    func getSwitchButtonsTitles() -> [String]
    func passDataToScene(segue: UIStoryboardSegue, withType: MyDataSection)
}

protocol MyDataScreenRouterInterface {
    func presentMyDataExplanation(withType: MyDataSection)
    func presentMyDataSelection()
    func dismiss()
    func passDataToScene(segue: UIStoryboardSegue, withType: MyDataSection)
}

protocol MyDataWorkerInterface {
    func myDataSections() -> MyDataScreenModel
    func myDataSelectionSections() -> MyDataSelectionModel
    func getDailyResults(around date: Date,
                         withMonthsBefore: Int,
                         monthsAfter: Int,
                         _ completion: @escaping([Date: MyDataDailyCheckInModel]?, Error?) -> Void)
}
