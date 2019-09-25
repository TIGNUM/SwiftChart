//
//  SolveResultsModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum SolveTriggerType: String {
    case midsetShifter
    case tbvGenerator
    case recoveryPlaner
}

enum ButtonItem {
    case cancel
    case done
    case save

    var title: String {
        switch self {
        case .cancel: return ScreenTitleService.main.localizedString(for: .ButtonTitleCancel)
        case .done: return ScreenTitleService.main.localizedString(for: .ButtonTitleDone)
        case .save: return ScreenTitleService.main.localizedString(for: .ButtonTitleSaveContinue)
        }
    }

    var width: CGFloat {
        switch self {
        case .cancel: return .Cancel
        case .done: return .Done
        case .save: return .SaveAndContinue
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .cancel: return .sand
        case .done: return .carbon
        case .save: return .carbon
        }
    }

    var borderColor: UIColor {
        switch self {
        case .cancel: return .accent40
        case .done: return .carbon
        case .save: return .carbon
        }
    }
}

enum ResultType {
    case solveDailyBrief
    case solveDecisionTree
    case recoveryDecisionTree
    case recoveryMyPlans

    var contentId: Int {
        switch self {
        case .recoveryDecisionTree,
             .recoveryMyPlans:
            return 101291
        default:
            return 0
        }
    }

    var buttonItems: [ButtonItem] {
        switch self {
        case .solveDailyBrief: return [.save, .cancel]
        case .solveDecisionTree: return [.save]
        case .recoveryDecisionTree: return [.save, .cancel]
        case .recoveryMyPlans: return [.done]
        }
    }
}

struct SolveResult {
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
