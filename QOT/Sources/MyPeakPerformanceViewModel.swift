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
}
