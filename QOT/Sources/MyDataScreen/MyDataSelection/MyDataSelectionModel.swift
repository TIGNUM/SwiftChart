//
//  MyDataSelectionModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct MyDataSelectionModel {
    static let maximumSelectableItems = 3
    var myDataSelectionItems: [SelectionItem]

    struct SelectionItem: Equatable {
        let myDataExplanationSection: MyDataParameter
        let title: String?
        let subtitle: String?
        var selected: Bool

        static func == (lhs: SelectionItem, rhs: SelectionItem) -> Bool {
            return lhs.myDataExplanationSection == rhs.myDataExplanationSection &&
                   lhs.title == rhs.title &&
                   lhs.subtitle == rhs.subtitle &&
                   lhs.selected == rhs.selected
        }
    }

    func selectedItems() -> [SelectionItem] {
        return myDataSelectionItems.filter { $0.selected }
    }

    static var sectionValues: [MyDataParameter] {
        return [.SQL, .SQN, .tenDL, .fiveDRR, .fiveDRL, .fiveDIR]
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
             return .white
         }
     }
}
