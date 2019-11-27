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
        case .cancel: return AppTextService.get(AppTextKey.generic_view_button_cancel)
        case .done: return AppTextService.get(AppTextKey.generic_view_button_done)
        case .save: return AppTextService.get(AppTextKey.coach_solve_result_alert_follow_up_button_activate)
        }
    }

    var width: CGFloat {
        switch self {
        case .cancel: return .Cancel
        case .done: return .Done
        case .save: return .Save
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
    case mindsetShifterDecisionTree
    case mindsetShifterMyPlans
    case prepareDecisionTree
    case prepareMyPlans
    case prepareDailyBrief

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
        case .solveDailyBrief,
             .solveDecisionTree,
             .recoveryMyPlans,
             .mindsetShifterMyPlans,
             .prepareMyPlans,
             .prepareDailyBrief: return [.done]
        case .recoveryDecisionTree,
             .mindsetShifterDecisionTree,
             .prepareDecisionTree: return [.save, .cancel]
        }
    }
}

struct SolveResult {
    let type: ResultType
    let items: [Item]

    enum Item {
        case header(title: String, solution: String)
        case strategy(id: Int, title: String, minsToRead: String, hasHeader: Bool, headerTitle: String)
        case strategyContentItem(id: Int, title: String, minsToRead: String, hasHeader: Bool, headerTitle: String)
        case trigger(type: SolveTriggerType?, header: String, description: String, buttonText: String)
        case fiveDayPlay(hasHeader: Bool, text: String)
        case followUp(title: String, subtitle: String)
        case exclusiveContent(id: Int, hasHeader: Bool, title: String, minsToRead: String, headerTitle: String)
        case fatigue(sympton: String)
        case cause(cause: String, explanation: String)
    }
}
