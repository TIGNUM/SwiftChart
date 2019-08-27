//
//  MyDataScreenModel.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit
import qot_dal

enum MyDataParameter: Int, CaseIterable {
    case SQL = 0
    case SQN
    case tenDL
    case fiveDRR
    case fiveDRL
    case fiveDIR
    case IR
}

struct MyDataDailyCheckInModel: Codable {
    var date: Date
    var impactReadiness: Double?
    var sleepQuality: Double?
    var sleepQuantity: Double?
    var fiveDayRecovery: Double?
    var fiveDayLoad: Double?
    var tenDayLoad: Double?
    var fiveDayImpactReadiness: Double?
    var averageUsersImpactReadiness: Double?

    init(withDailyCheckInResult: QDMDailyCheckInResult) {
        date = withDailyCheckInResult.date
        impactReadiness = withDailyCheckInResult.impactReadiness
        sleepQuality = withDailyCheckInResult.sleepQuality
        sleepQuantity = withDailyCheckInResult.sleepQuantity
        tenDayLoad = withDailyCheckInResult.load
        fiveDayRecovery = ((withDailyCheckInResult.sleepQuantity ?? 0) + (withDailyCheckInResult.sleepQuality ?? 0))/2
        averageUsersImpactReadiness = 70
    }
}

enum MyDataSection: Int, CaseIterable {
    case dailyImpact = 0
    case heatMap

    static var sectionValues: [MyDataSection] {
        return [.dailyImpact, .heatMap]
    }
}

struct MyDataScreenModel {
    let myDataItems: [Item]
    var selectedHeatMapMode: HeatMapMode = .dailyIR
    
    struct Item {
        let myDataSection: MyDataSection
        let title: String?
        let subtitle: String?
    }

    // MARK: - Properties

    func sectionItem(at index: Int) -> MyDataSection {
        return MyDataSection.sectionValues.item(at: index)
    }
}
