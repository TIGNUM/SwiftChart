//
//  MypeakperformanceTitleModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 08.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class MypeakperformanceTitleModel: MyPerformanceModelItem {

    // MARK: - Properties
    var type: MyPeakPerformanceModelItemType {
        return .TITLE
    }
    var title: String?

    // MARK: - Init
    init(title: String?) {
        self.title = title
    }
}


