//
//  DailyBriefPeakPerformanceViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 02.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyPeakPerformanceCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
//    var peakPerformanceSectionList = [MyPerformanceModelItem]()

    // MARK: - Init

    var title: MypeakPerformanceTitle
    var sections: [MyPeakPerformanceSections]

    struct MypeakPerformanceTitle {
        let title: String
    }

    struct MyPeakPerformanceSections {
        let sections: MyPeakPerformanceSectionRow
        let rows: [MyPeakPerformanceRow]
    }

    struct MyPeakPerformanceSectionRow {
        let sectionSubtitle: String?
        let sectionContent: String?
    }

    struct MyPeakPerformanceRow {
        let title: String?
        let subtitle: String?
        let qdmUserPreparation: QDMUserPreparation?
    }

    init(title: MypeakPerformanceTitle, sections: [MyPeakPerformanceSections], domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.sections = sections
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? MyPeakPerformanceCellViewModel else {
            return false
        }

        let eventDates = Set(domainModel?.preparations?.compactMap({ $0.eventDate }) ?? [])
        let sourceEventDates = Set(source.domainModel?.preparations?.compactMap({ $0.eventDate }) ?? [])

        let eventTitles = Set(domainModel?.preparations?.compactMap({ $0.eventTitle }) ?? [])
        let sourceEventTitles = Set(source.domainModel?.preparations?.compactMap({ $0.eventTitle }) ?? [])

        return eventDates == sourceEventDates && eventTitles == sourceEventTitles
    }
}
