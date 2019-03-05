//
//  VisionGeneratorModels.swift
//  QOT
//
//  Created by karmic on 10.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct VisionGeneratorChoice: ChatChoice {

    enum QuestionType: String {
        case intro = "tbv-generator-key-intro"
        case instructions = "tbv-generator-key-instructions"
        case home = "tbv-generator-key-home"
        case work = "tbv-generator-key-work"
        case next = "tbv-generator-key-next"
        case create = "tbv-generator-key-create"
        case picture = "tbv-generator-key-picture"
        case review = "tbv-generator-key-review"

        var key: String {
            return rawValue
        }

        var multiSelection: Bool {
            switch self {
            case .home,
                 .work,
                 .picture: return true
            default: return false
            }
        }

        var isAutoscrollSnapable: Bool {
            switch self {
            case .work: return false
            default: return true
            }
        }

        var nextType: QuestionType {
            switch self {
            case .intro: return .instructions
            case .instructions: return .work
            case .work: return .home
            case .home: return .create
            case .create: return .next
            case .next: return .picture
            case .picture,
                 .review: return .review
            }
        }

        var visionGenerated: Bool {
            switch self {
            case .intro,
                 .instructions,
                 .home,
                 .work,
                 .next: return false
            case .create,
                 .picture,
                 .review: return true
            }
        }

        var bottomButtonIsHidden: Bool {
            switch self {
            case .work,
                 .home: return false
            default: return true
            }
        }

        func bottomButtonTitle(selectedItemCount: Int) -> String {
            switch self {
            case .work,
                 .home: return String(format: "Pick %d to continue", 4 - selectedItemCount)
            default: return ""
            }
        }
    }

    let title: String
    let type: QuestionType
    let targetID: Int?
    let target: AnswerDecision.Target?

    static let expectedChoiceCount = 4
}

struct VisionGeneratorAlertModel {
    let title: String
    let message: String
    let buttonTitleCancel: String
    let buttonTitleDefault: String

    enum Tags: String {
        case title = "tbv_generator_alert_not_saved_title"
        case message = "tbv_generator_alert_not_saved_message"
        case buttonTitleCancel = "tbv_generator_alert_not_saved_button_title_cancel"
        case buttonTitleDefault = "tbv_generator_alert_not_saved_button_title_default"

        var predicate: NSPredicate {
            return NSPredicate(tag: rawValue)
        }
    }
}
