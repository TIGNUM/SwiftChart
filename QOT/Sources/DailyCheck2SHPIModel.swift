//
//  DailyCheckInsightsSHPIVIewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 02.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct DailyCheck2SHPIModel {
    // MARK: - Properties
    let title: String?
    let shpiContent: String?
    let shpiRating: Int?

     // MARK: - Init

    init(title: String?, shpiContent: String?, shpiRating: Int?) {
        self.title = title
        self.shpiContent = shpiContent
        self.shpiRating = shpiRating
    }
}
