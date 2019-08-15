//
//  ConfirmationModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Confirmation {
    let title: String
    let description: String
    let buttonTitleDismiss: String
    let buttonTitleConfirm: String

    enum Kind {
        case mindsetShifter
        case recovery
        case solve

        var tags: [Confirmation.Tag] {
            switch self {
            case .mindsetShifter:
                return [.mindsetTitle, .mindsetDescription, .mindsetButtonNo, .mindsetButtonYes]
            case .recovery:
                return [.recoveryTitle, .recoveryDescription, .recoveryButtonNo, .recoveryButtonYes]
            case .solve:
                return [.solveTitle, .solveDescription, .solveButtonNo, .solveButtonYes]
            }
        }
    }

    enum Tag: String, CaseIterable, Predicatable {
        case mindsetTitle = "confirmationview-title-mindsetshifter"
        case mindsetDescription = "confirmationview-subtitle-mindsetshifter"
        case mindsetButtonYes = "confirmationview-button-yes-mindsetshifter"
        case mindsetButtonNo = "confirmationview-button-no-mindsetshifter"
        case solveTitle = "confirmationview-title-solve"
        case solveDescription = "confirmationview-subtitle-solve"
        case solveButtonYes = "confirmationview-button-yes-solve"
        case solveButtonNo = "confirmationview-button-no-solve"
        case recoveryTitle = "confirmationview-title-recovery"
        case recoveryDescription = "confirmationview-subtitle-recovery"
        case recoveryButtonYes = "confirmationview-button-yes-recovery"
        case recoveryButtonNo = "confirmationview-button-no-recovery"

        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
