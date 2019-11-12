//
//  MyToBeVisionTrackerWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TBVRateHistoryWorker {

    lazy var isDataType = displayType == .data
    lazy var subtitle = ScreenTitleService.main.localizedString(for: isDataType ? .TbvDataSubtitle : .TbvTrackerSubtitle)
    lazy var title = ScreenTitleService.main.localizedString(for: isDataType ? .TbvDataTitle : .TbvTrackerTitle)
    lazy var graphTitle = ScreenTitleService.main.localizedString(for: isDataType ? .TbvDataGraphTitle : .TbvTrackerGraphTitle)

    private let displayType: TBVGraph.DisplayType
    var dataModel: ToBeVisionReport?

    init(_ displayType: TBVGraph.DisplayType) {
        self.displayType = displayType
    }

    func getData(_ completion: @escaping (ToBeVisionReport) -> Void) {
        UserService.main.getToBeVisionTrackingReport(last: 3) { [weak self] (report) in
            guard let strongSelf = self else { return }
            strongSelf.dataModel = ToBeVisionReport(title: strongSelf.title,
                                                    subtitle: strongSelf.subtitle,
                                                    selectedDate: report.days.sorted(by: <).last!,
                                                    report: report)
            completion(strongSelf.dataModel!)
        }
    }

    func setSelection(for date: Date) {
        dataModel?.selectedDate = date
    }

    var sentences: [QDMToBeVisionSentence] {
        if let dataModel = dataModel {
            return dataModel.report.sentences.filter { ($0.ratings[dataModel.selectedDate] ?? -1) > 0 }
        }
        return []
    }

    var selectedDate: Date {
        return dataModel!.selectedDate
    }

    var average: [Date: Double] {
        return dataModel?.report.averages ?? [:]
    }

    var days: [Date] {
        return dataModel?.report.days.sorted(by: <) ?? []
    }
}
