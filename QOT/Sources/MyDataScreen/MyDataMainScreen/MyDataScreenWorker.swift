//
//  MyDataScreenWorker.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit
import qot_dal

final class MyDataScreenWorker {

    // MARK: - Properties
    private let dataService: qot_dal.MyDataService
    var initialDataSelectionSections = MyDataSelectionModel(myDataSelectionItems: [])
    var firstLoad: Bool = true
    var datasourceLoaded: Bool = false
    var oldestAvailableDate: Date = Date().dateAfterYears(-1)
    var heatMapFirstDayOfVisibleMonth: Date = Date().firstDayOfMonth()
    var heatMapLastDayOfVisibleMonth: Date = Date().lastDayOfMonth()
    var selectedHeatMapMode: HeatMapMode = .dailyIR
    var graphFirstWeekdaysDatasource: [Date] = []
    var impactReadinessDatasource: [Date: MyDataDailyCheckInModel] = [:]
    var visibleGraphHasData: Bool = false

    // MARK: - Init

    init(dataService: qot_dal.MyDataService) {
        self.dataService = dataService
        self.graphFirstWeekdaysDatasource = firstWeekdays(between: oldestAvailableDate, and: Date())
    }
}

extension MyDataScreenWorker: MyDataWorkerInterface {
    func myDataHeatMapButtonTitles() -> [String] {
        return [AppTextService.get(AppTextKey.my_qot_my_data_section_heat_map_button_ir),
                AppTextService.get(AppTextKey.my_qot_my_data_section_heat_map_button_ir_5_day)]
    }
    func myDataSections() -> MyDataScreenModel {
        return MyDataScreenModel(myDataItems: MyDataSection.allCases.map {
                        return MyDataScreenModel.Item(myDataSection: $0,
                                                      title: self.myDataSectionTitle(for: $0),
                                                      subtitle: self.myDataSectionSubtitle(for: $0))
                                               })
    }

    func myDataSectionTitle(for myDataItem: MyDataSection) -> String? {
        switch myDataItem {
        case .dailyImpact:
            return AppTextService.get(AppTextKey.my_qot_my_data_section_impact_readiness_title)
        case .heatMap:
            return AppTextService.get(AppTextKey.my_qot_my_data_section_heat_map_title)
        }
    }

    func myDataSectionSubtitle(for myDataItem: MyDataSection) -> String? {
        switch myDataItem {
        case .dailyImpact:
            return AppTextService.get(AppTextKey.my_qot_my_data_section_impact_readiness_body)
        case .heatMap:
            return AppTextService.get(AppTextKey.my_qot_my_data_section_heat_map_body)
        }
    }

    func myDataSelectionSections() -> MyDataSelectionModel {
        var sectionModel = MyDataSelectionModel(myDataSelectionItems: [])
        guard let selectedValues = UserDefault.myDataSelectedItems.object as? [Int] else {
            return sectionModel
        }

        for rawValue in selectedValues {
            if let parameterValue = MyDataParameter(rawValue: rawValue) {
                sectionModel.myDataSelectionItems.append(MyDataSelectionModel.SelectionItem(myDataExplanationSection: parameterValue,
                                                                                            title: self.myDataSelectionSectionTitles(for: parameterValue),
                                                                                            selected: true))
            }

        }
        initialDataSelectionSections = sectionModel
        return sectionModel
    }

    func myDataSelectionSectionTitles(for myDataSelectionItem: MyDataParameter) -> String? {
        switch myDataSelectionItem {
        case .SQL:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_sleep_quality_title)
        case .SQN:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_sleep_quantity_title)
        case .tenDL:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_ten_day_load_title)
        case .fiveDRR:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_five_day_recovery_title)
        case .fiveDRL:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_five_day_load_title)
        case .fiveDIR:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_five_day_ir_title)
        case .IR:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_ir_title)
        }
    }

    func getDailyResults(around date: Date,
                         withMonthsBefore: Int,
                         monthsAfter: Int,
                         _ completion: @escaping([Date: MyDataDailyCheckInModel]?, Error?) -> Void) {
            let beginDate = date.dayAfter(months: -withMonthsBefore).firstDayOfMonth()
            let endDate = date.dayAfter(months: monthsAfter).lastDayOfMonth()
        MyDataService.main.getDailyCheckInResults(from: beginDate, to: endDate) { [weak self] (results, initialized, error) in
            guard let results = results, let s = self else {
                completion(nil, error)
                return
            }
            s.datasourceLoaded = true
            let convertedResults = results.map({ (result) -> MyDataDailyCheckInModel in
                return MyDataDailyCheckInModel.init(withDailyCheckInResult: result)
            })
            var resultsDict: [Date: MyDataDailyCheckInModel] = [:]
            for result in convertedResults {
                resultsDict[result.date.beginingOfDate()] = result
            }
            s.impactReadinessDatasource = resultsDict
            completion(resultsDict, error)
        }
    }

    static func heatMapColor(forImpactReadiness ir: Double) -> UIColor {
        if ir <= 50 {
            return .heatMapDarkBlue
        } else if ir <= 64 {
            return .heatMapBlue
        } else if ir <= 74 {
            return .heatMapDarkRed
        } else if ir < 85 {
            return .heatMapRed
        } else {
            return .heatMapBrightRed
        }
    }

    func firstWeekdays(between firstDate: Date, and secondDate: Date) -> [Date] {
        var weekdays: [Date] = []
        var date = firstDate.firstDayOfMonth().firstDayOfWeek()
        while date < secondDate {
            weekdays.append(date)
            date = date.dateAfterDays(7)
        }
        return weekdays
    }
}
