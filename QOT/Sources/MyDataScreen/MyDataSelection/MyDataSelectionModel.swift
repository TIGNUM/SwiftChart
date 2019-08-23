//
//  MyDataSelectionModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct MyDataSelectionModel {
    var myDataSelectionItems: [SelectionItem]

    struct SelectionItem: Equatable {
        let myDataExplanationSection: MyDataParameter
        let title: String?
        var selected: Bool

        static func ==(lhs: SelectionItem, rhs: SelectionItem) -> Bool {
            return lhs.myDataExplanationSection == rhs.myDataExplanationSection &&
                   lhs.title == rhs.title &&
                   lhs.selected == rhs.selected
        }
    }

    static var sectionValues: [MyDataParameter] {
        return [.SQL, .SQN, .tenDL, .fiveDRR, .fiveDRL, .fiveDIR]
    }
}
