//
//  MindsetResult.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct MindsetResult {
    let resultType: ResultType
    let sections: [Section]

    enum Section {
        case header(title: String, subtitle: String)
        case trigger(title: String, item: String)
        case reactions(title: String, items: [String])
        case lowToHigh(title: String, lowTitle: String, lowItems: [String], highTitle: String, highItems: [String])
        case vision(title: String, text: String)
    }

    struct Item {
        let triggerAnswerId: Int?
        let toBeVisionText: String?
        let reactionsAnswerIds: [Int]
        let lowPerformanceAnswerIds: [Int]
        let highPerformanceContentItemIds: [Int]
    }
}
