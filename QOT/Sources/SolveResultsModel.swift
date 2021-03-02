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
        case .cancel: return AppTextService.get(.generic_view_button_cancel)
        case .done: return AppTextService.get(.generic_view_button_done)
        case .save: return AppTextService.get(.generic_view_button_save)
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
        case .cancel: return .white
        case .done: return .white
        case .save: return .white
        }
    }

    var borderColor: UIColor {
        switch self {
        case .cancel: return .black
        case .done: return .black
        case .save: return .black
        }
    }
}

enum ResultType {
    case solveDailyBrief
    case solveDecisionTree
    case recoveryDecisionTree
    case recoveryMyPlans
    case mindsetShifterDecisionTree
    case mindsetShifterBucket
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
            return .zero
        }
    }

    var buttonItems: [ButtonItem] {
        switch self {
        case .solveDailyBrief,
             .recoveryMyPlans,
             .mindsetShifterMyPlans,
             .prepareMyPlans,
             .prepareDailyBrief,
             .mindsetShifterBucket,
             .solveDecisionTree: return [.done]
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
