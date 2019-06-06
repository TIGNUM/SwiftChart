//
//  QuestionKey.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 21.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

// MARK: - Question Key

enum QuestionKey {
    enum ToBeVision: String {
        case intro = "tbv-generator-key-intro"
        case instructions = "tbv-generator-key-instructions"
        case home = "tbv-generator-key-home"
        case work = "tbv-generator-key-work"
        case next = "tbv-generator-key-next"
        case create = "tbv-generator-key-create"
        case picture = "tbv-generator-key-picture"
        case review = "tbv-generator-key-review"
    }

    enum MindsetShifter: String {
        case intro = "mindsetshifter-key-intro"
        case openTBV = "mindsetshifter-open-tbv"
        case showTBV = "mindsetshifter-show-tbv"
        case check = "mindsetshifter-check-plan"
    }

    enum MindsetShifterTBV: String {
        case intro = "mindsetshifter-tbv-generator-key-intro"
        case work = "mindsetshifter-tbv-generator-key-work"
        case home = "mindsetshifter-tbv-generator-home-work"
        case review = "mindsetshifter-tbv-generator-key-review"
    }

    enum Prepare: String {
        case intro = "prepare-key-intro"
    }
}
