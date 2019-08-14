//
//  MyPeakPerformanceCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 07.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class MyPeakPerformanceRowModel: MyPerformanceModelItem {
    internal init(title: String?, subTitle: String?) {
        self.title = title
        self.subTitle = subTitle
    }
    var type: MyPeakPerformanceModelItemType {
        return .SECTION
    }

    var title: String?
    var subTitle: String?
}
