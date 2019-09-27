//
//  MYTBVDataViewModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MYTBVDataViewModel {
    var title: String?
    var subHeading: MYTBVDataSubHeading?
    var graph: MYTBVDataGraph?
    var answers: [MYTBVDataAnswer]?
    var selectedDate: Date?
    var selectedAnswers: [MYTBVDataAnswer]?

    enum Section: Int, CaseIterable {
        case header = 0
        case graph
        case sentence

        var height: CGFloat {
            switch self {
            case .header:
                return CGFloat(150)
            case .sentence:
                return CGFloat(68)
            default:
                return CGFloat(0.1)
            }
        }
    }
}

struct MYTBVDataSubHeading {
    let title: String
}
struct MYTBVDataGraph {
    var heading: String?
    var ratings: [TBVGraph.Rating]?
}
struct MYTBVDataAnswer {
    var answer: String?
    var ratings: [MYTBVDataRating]
}
struct MYTBVDataRating {
    let value: Int?
    let date: Date?
    var isSelected: Bool
}
