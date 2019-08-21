//
//  MyDataExplanationModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

enum MyDataExplanationSection: Int, CaseIterable {
    case SQL = 0
    case SQN
    case tenDL
    case fiveDRR
    case fiveDRL
    case fiveDIR
    case IR
    
    static var sectionValues: [MyDataExplanationSection] {
        return [.SQL, .SQN, .tenDL, .fiveDRR, .fiveDRL, .fiveDIR, .IR]
    }
}

struct MyDataExplanationModel {
    let myDataExplanationItems: [ExplanationItem]
    
    struct ExplanationItem {
        let myDataExplanationSection: MyDataExplanationSection
        let title: String?
        let subtitle: String?
    }
}
