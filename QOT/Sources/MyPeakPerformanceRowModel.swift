//
//  MyPeakPerformanceRowModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 08.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceRowModel: MyPerformanceModelItem {

    // MARK: - Properties
    var type: MyPeakPerformanceModelItemType {
        return .ROW
    }

    var title: String?
    var subtitle: String?

    // MARK: - Init
    init(title: String?, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }
}
