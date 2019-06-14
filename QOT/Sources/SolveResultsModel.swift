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
}

struct SolveResults {
    let items: [Item]

    enum Item {
        case header(title: String, solution: String)
        case strategy(id: Int, title: String, minsToRead: String, hasHeader: Bool)
        case trigger(type: SolveTriggerType, header: String, description: String, buttonText: String)
        case fiveDayPlay(hasHeader: Bool, text: String)
        case followUp(title: String, subtitle: String)
    }
}
