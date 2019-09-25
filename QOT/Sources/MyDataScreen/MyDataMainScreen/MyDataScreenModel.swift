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
    static let defaultAverageValue: Double = 70
    var date: Date
    // all values below are percentages with maximum value of 100
    var impactReadiness: Double?
    var sleepQuality: Double?
    var sleepQuantity: Double?
    var fiveDayRecovery: Double?
    var fiveDayLoad: Double?
    var tenDayLoad: Double?
    var fiveDayImpactReadiness: Double?
    var averageUsersImpactReadiness: Double?
    var tenDaysFutureLoad: Double?

    init(withDailyCheckInResult: QDMDailyCheckInResult) {
        date = withDailyCheckInResult.date
        impactReadiness = min((withDailyCheckInResult.impactReadiness ?? 0), 100)
        sleepQuality = min((withDailyCheckInResult.sleepQuality ?? 0) * 10, 100)
        sleepQuantity = min((withDailyCheckInResult.sleepQuantity ?? 0) * 10, 100)
        fiveDayRecovery = min((withDailyCheckInResult.fiveDaysRecovery ?? 0), 100)
        fiveDayLoad = min((withDailyCheckInResult.fiveDaysload ?? 0) * 10, 100)
        tenDayLoad = min((withDailyCheckInResult.tenDaysFutureLoad ?? 0) * 10, 100)
        fiveDayImpactReadiness = min((withDailyCheckInResult.fiveDaysImpactReadiness ?? 0), 100)
        let realAverage = withDailyCheckInResult.impactReadinessAverageMinimumThreshold ?? MyDataDailyCheckInModel.defaultAverageValue
        averageUsersImpactReadiness = min(realAverage, 100)
        tenDaysFutureLoad = (withDailyCheckInResult.tenDaysFutureLoad ?? 0) * 10
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
    struct Item {
        let myDataSection: MyDataSection
        let title: String?
        let subtitle: String?
    }

    // MARK: - Properties

    func sectionItem(at index: Int) -> MyDataSection {
        return MyDataSection.sectionValues.at(index: index) ?? .dailyImpact
    }
}
