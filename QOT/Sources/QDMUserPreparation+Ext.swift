//
//  QDMUserPreparation+Ext.swift
//  QOT
//
//  Created by karmic on 18.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol EditResult {
    var canEditIntentions: Bool { get }
    var answerFilterCritical: String { get }
}

extension QDMUserPreparation: EditResult {
    var canEditIntentions: Bool {
        return answerFilter != nil ||
            !(feelAnswers?.first?.keys.filter { knowAnswers?.last?.keys.contains($0) == true }.first?.isEmpty ?? true)
    }

    var answerFilterCritical: String {
        return feelAnswers?.first?.keys.filter { knowAnswers?.last?.keys.contains($0) == true }.first ?? ""
    }
}

extension QDMUserPreparation.Level {
    var contentID: Int {
        switch self {
        case .LEVEL_ON_THE_GO: return 101256
        case .LEVEL_DAILY: return 101258
        case .LEVEL_CRITICAL: return 101260
        default: return .zero
        }
    }

    var key: String? {
        switch self {
        case .LEVEL_ON_THE_GO: return nil
        case .LEVEL_DAILY: return Prepare.AnswerKey.EventTypeSelectionDaily
        case .LEVEL_CRITICAL: return Prepare.AnswerKey.EventTypeSelectionCritical
        default: return nil
        }
    }
}
