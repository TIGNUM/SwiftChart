//
//  SolveResultsModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

enum SolveTriggerType: String {
    case midsetShifter
    case tbvGenerator
    case recoveryPlaner
}

enum ResultType {
    case solve
    case recovery

    var contentId: Int {
        switch self {
        case .recovery:
            return 101291
        case .solve:
            return 0
        }
    }

    var confirmationKind: Confirmation.Kind {
        switch self {
        case .recovery:
            return .recovery
        case .solve:
            return .solve
        }
    }
}

struct SolveResults {
    let type: ResultType
    let items: [Item]

    enum Item {
        case header(title: String, solution: String)
        case strategy(id: Int, title: String, minsToRead: String, hasHeader: Bool, headerTitle: String)
        case trigger(type: SolveTriggerType?, header: String, description: String, buttonText: String)
        case fiveDayPlay(hasHeader: Bool, text: String)
        case followUp(title: String, subtitle: String)
        case exclusiveContent(id: Int, hasHeader: Bool, title: String, minsToRead: String, headerTitle: String)
        case fatigue(sympton: String)
        case cause(cause: String, explanation: String)
    }
}
