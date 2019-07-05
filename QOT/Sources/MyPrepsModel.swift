//
//  MyPrepsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct MyPrepsModel {

    var prepItems: [Items]

    struct Items {
        var title: String
        var date: String
        var eventType: String
        let qdmPrep: QDMUserPreparation
    }
}

struct RecoveriesModel {

    var prepItems: [Items]

    struct Items {
        var title: String
        var date: String
        let qdmRec: QDMRecovery3D
    }
}

struct MindsetShiftersModel {

    var prepItems: [Items]

    struct Items {
        var title: String
        var date: String
        let qdmMind: QDMMindsetShifter
    }
}
