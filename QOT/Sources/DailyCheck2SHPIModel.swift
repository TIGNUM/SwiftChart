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
    let shpiQuestion: String?

     // MARK: - Init

    init(title: String?, shpiContent: String?, shpiRating: Int?, shpiQuestion: String?) {
        self.title = title
        self.shpiContent = shpiContent
        self.shpiRating = shpiRating
        self.shpiQuestion = shpiQuestion
    }
}
