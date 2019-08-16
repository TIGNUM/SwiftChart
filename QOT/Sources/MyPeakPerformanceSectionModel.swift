//
//  MyPeakPerformanceSectionModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 08.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceSectionModel: MyPerformanceModelItem {

    // MARK: - Properties
    var type: MyPeakPerformanceModelItemType {
        return .SECTION
    }
    var sectionSubtitle: String?
    var sectionContent: String?

    // MARK: - Init
    init(sectionSubtitle: String?, sectionContent: String?) {
        self.sectionSubtitle = sectionSubtitle
        self.sectionContent = sectionContent
    }
}
