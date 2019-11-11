//
//  TBVRateHistory.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct TBVRateHistory {
//    let title: String
//    let subtitle: String
//    var graph: MYTBVDataGraph?
//    var answers: [MYTBVDataAnswer]?
//    var selectedDate: Date?
//    var selectedAnswers: [MYTBVDataAnswer]?

    enum Section: Int, CaseIterable {
        case header = 0
        case graph
        case sentence

        var height: CGFloat {
            switch self {
            case .header: return CGFloat(150)
            case .sentence: return CGFloat(68)
            default: return CGFloat(0.1)
            }
        }
    }

    enum DisplayType {
        case tracker
        case data
    }
}

struct MYTBVDataGraph {
    var heading: String?
    var ratings: [TBVGraph.Rating]?
}

//struct MYTBVDataAnswer {
//    var answer: String?
//    var ratings: [MYTBVDataRating]
//}
//
//struct MYTBVDataRating {
//    let value: Int?
//    let isoDate: Date?
//    var isSelected: Bool
//}

class ToBeVisionReport {
    let title: String
    let subtitle: String
    var selectedDate: Date
    let report: QDMToBeVisionRatingReport

    init(title: String,
         subtitle: String,
         selectedDate: Date,
         report: QDMToBeVisionRatingReport) {
        self.title = title
        self.subtitle = subtitle
        self.selectedDate = selectedDate
        self.report = report
    }
}
