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

    init(withDailyCheckInResult: QDMDailyCheckInResult, _ average: Double = MyDataDailyCheckInModel.defaultAverageValue) {
        date = withDailyCheckInResult.date
        impactReadiness = (withDailyCheckInResult.impactReadiness ?? 0)
        sleepQuality = (withDailyCheckInResult.sleepQuality ?? 0) * 10
        if let quantity = withDailyCheckInResult.sleepQuantity,
            let target = withDailyCheckInResult.targetSleepQuantity,
            quantity > 0 {
            sleepQuantity = max(quantity/target*100, 100)
        }
        if let fiveDaySleepQuality = withDailyCheckInResult.fiveDaysSleepQuality,
           let fiveDaySleepQuantity = withDailyCheckInResult.fiveDaysSleepQuantity,
           let target = withDailyCheckInResult.targetSleepQuantity,
            withDailyCheckInResult.hasFiveDaysDataForSleepQuality,
            withDailyCheckInResult.hasFiveDaysDataForSleepQuantity {
            fiveDayRecovery = (fiveDaySleepQuantity/5/target*100 + fiveDaySleepQuality*10)/2
        }

        fiveDayLoad = (withDailyCheckInResult.fiveDaysload ?? 0) * 10
        tenDayLoad = (withDailyCheckInResult.load ?? 0) * 10
        fiveDayImpactReadiness = (withDailyCheckInResult.fiveDaysImpactReadiness ?? 0)
        averageUsersImpactReadiness = (average >= MyDataDailyCheckInModel.defaultAverageValue) ? average : MyDataDailyCheckInModel.defaultAverageValue
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
