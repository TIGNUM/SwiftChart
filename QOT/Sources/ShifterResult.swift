//
//  ShifterResult.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct ShifterResult {
    let sections: [Section]
    let buttonTitle: String

    enum Section {
        case header(title: String, subtitle: String)
        case trigger(title: String, item: String)
        case reactions(title: String, items: [String])
        case lowToHigh(title: String, lowTitle: String, lowItems: [String], highTitle: String, highItems: [String])
        case vision(title: String, text: String)
    }

    struct Item {
        let triggerAnswerId: Int?
        let reactionsAnswerIds: [Int]
        let lowPerformanceAnswerIds: [Int]
        let highPerformanceContentItemIds: [Int]
        let trigger: String
        let reactions: [String]
        let lowPerformanceItems: [String]
        let highPerformanceItems: [String]
    }

    enum Tag: String, CaseIterable, Predicatable {
        case headerTitle = "mindset-shifter-checklist-header-title"
        case headerSubtitle = "mindset-shifter-checklist-header-subtitle"
        case triggerTitle = "mindset-shifter-checklist-trigger-title"
        case reactionsTitle = "mindset-shifter-checklist-reactions-title"
        case lowToHighTitle = "mindset-shifter-checklist-negativeToPositive-title"
        case lowTitle = "mindset-shifter-checklist-negativeToPositive-lowTitle"
        case highTitle = "mindset-shifter-checklist-negativeToPositive-highTitle"
        case visionTitle = "mindset-shifter-checklist-vision-Title"
        case buttonTitle = "mindset-shifter-checklist-save-button-text"

        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
