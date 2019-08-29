//
//  MyDataExplanationModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct MyDataExplanationModel {
    let myDataExplanationItems: [ExplanationItem]

    struct ExplanationItem {
        let myDataExplanationSection: MyDataParameter
        let title: String?
        let subtitle: String?
    }

    static func color(for parameter: MyDataParameter) -> UIColor {
        switch parameter {
        case .fiveDIR:
            return .fiveDayImpactReadiness
        case .fiveDRL:
            return .fiveDayLoad
        case .fiveDRR:
            return .fiveDayRecovery
        case .tenDL:
            return .tenDayLoad
        case .SQL:
            return .sleepQuality
        case .SQN:
            return .sleepQuantity
        case .IR:
            return .sand
        }
    }
}
