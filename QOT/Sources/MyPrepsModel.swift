//
//  MyPrepsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct MyPlansViewModel {
    let title: String
    let titleEditMode: String

    let myPrepsTitle: String
    let myPrepsBody: String

    let mindsetShifterTitle: String
    let mindsetShifterBody: String

    let recoveryTitle: String
    let recoveryBody: String
}

struct MyPrepsModel {

    var items: [Item]

    struct Item {
        var title: String
        var date: String
        var eventType: String
        let qdmPrep: QDMUserPreparation
    }
}

struct RecoveriesModel {

    var items: [Item]

    struct Item {
        var title: String
        var date: String
        let qdmRec: QDMRecovery3D
    }
}

struct MindsetShiftersModel {

    var items: [Item]

    struct Item {
        var title: String
        var date: String
        let qdmMind: QDMMindsetShifter
    }
}
