//
//  MyPeakPerformanceRowModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 08.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyPeakPerformanceRowModel: MyPerformanceModelItem {

    // MARK: - Properties
    var type: MyPeakPerformanceModelItemType {
        return .ROW
    }

    var title: String?
    var subtitle: String?
    var qdmUserPreparation: QDMUserPreparation?

    // MARK: - Init
    init(qdmUserPreparation: QDMUserPreparation?, title: String?, subtitle: String?) {
        self.qdmUserPreparation = qdmUserPreparation
        self.title = title
        self.subtitle = subtitle
    }
}
