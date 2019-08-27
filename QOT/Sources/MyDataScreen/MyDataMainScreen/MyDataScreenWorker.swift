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

    // MARK: - Init

    init(dataService: qot_dal.MyDataService) {
        self.dataService = dataService
    }
}

extension MyDataScreenWorker: MyDataWorkerInterface {
    func myDataSections() -> MyDataScreenModel {
        return MyDataScreenModel(myDataItems: MyDataSection.allCases.map {
                        return MyDataScreenModel.Item(myDataSection: $0,
                                                      title: ScreenTitleService.main.myDataSectionTitles(for: $0),
                                                      subtitle: ScreenTitleService.main.myDataSectionSubtitles(for: $0))
                                               }, selectedHeatMapMode: .dailyIR)
    }

    func myDataSelectionSections() -> MyDataSelectionModel {
        var sectionModel = MyDataSelectionModel(myDataSelectionItems: [])
        guard let selectedValues = UserDefault.myDataSelectedItems.object as? [Int] else {
            return sectionModel
        }

        for rawValue in selectedValues {
            if let parameterValue = MyDataParameter(rawValue: rawValue) {
                sectionModel.myDataSelectionItems.append(MyDataSelectionModel.SelectionItem(myDataExplanationSection: parameterValue,
                                                                                            title: ScreenTitleService.main.myDataExplanationSectionTitles(for: parameterValue),
                                                                                            selected: true))
            }

        }
        initialDataSelectionSections = sectionModel
        return sectionModel
    }

    func getDailyResults(around date: Date,
                         withMonthsBefore: Int,
                         monthsAfter: Int,
                         _ completion: @escaping([Date: MyDataDailyCheckInModel]?, Error?) -> Void) {
            let beginDate = date.dayAfter(months: -withMonthsBefore).firstDayOfMonth()
            let endDate = date.dayAfter(months: monthsAfter).lastDayOfMonth()
        MyDataService.main.getDailyCheckInResults(from: beginDate, to: endDate) { (results, initialized, error) in
            guard let results = results else {
                completion(nil, error)
                return
            }
            let convertedResults = results.map({ (result) -> MyDataDailyCheckInModel in
                return MyDataDailyCheckInModel.init(withDailyCheckInResult: result)
            })
            var resultsDict: [Date: MyDataDailyCheckInModel] = [:]
            for result in convertedResults {
                resultsDict[result.date.beginingOfDate()] = result
            }
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
}
