//
//  ImpactReadinessScoreViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class ImpactReadinessScoreViewModel: BaseDailyBriefViewModel {

    var howYouFeelToday: String?
    var asteriskText: String?
    var sleepQuantityValue: Double?
    var hasFiveDaySleepQuantityValues: Bool?
    var sleepQualityValue: Double?
    var hasFiveDaySleepQualityValue: Bool?
    var loadValue: Double?
    var hasFiveDayLoadValue: Bool?
    var futureLoadValue: Double?
    var targetSleepQuantity: Double?
    var title: String?
    var subTitle: String?
    var impactDataModels: [ImpactDataViewModel]?
    var type = ImpactReadinessType.DAILY_CHECK_IN
    var maxTrackingDays: Int?
    struct ImpactDataViewModel {
        var title: String?
        var subTitle: String?
    }
    init(howYouFeelToday: String?,
         asteriskText: String?,
         sleepQuantityValue: Double?,
         hasFiveDaySleepQuantityValues: Bool?,
         sleepQualityValue: Double?,
         hasFiveDaySleepQualityValue: Bool?,
         loadValue: Double?,
         hasFiveDayLoadValue: Bool?,
         futureLoadValue: Double?,
         targetSleepQuantity: Double?,
         impactDataModels: [ImpactDataViewModel]?,
         maxTrackingDays: Int?,
         domainModel: QDMDailyBriefBucket,
         _ subIdentifier: String? = "") {

        self.howYouFeelToday = howYouFeelToday
        self.asteriskText = asteriskText

        self.sleepQuantityValue = sleepQuantityValue
        self.hasFiveDaySleepQuantityValues = hasFiveDaySleepQuantityValues
        self.sleepQualityValue = sleepQualityValue
        self.hasFiveDaySleepQualityValue = hasFiveDaySleepQualityValue

        self.targetSleepQuantity = targetSleepQuantity

        self.loadValue = loadValue
        self.hasFiveDayLoadValue = hasFiveDayLoadValue
        self.futureLoadValue = futureLoadValue
        self.maxTrackingDays = maxTrackingDays

        self.impactDataModels = impactDataModels
        super.init(domainModel, subIdentifier)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? ImpactReadinessScoreViewModel else {
            return false
        }
        return howYouFeelToday == source.howYouFeelToday &&
            sleepQuantityValue == source.sleepQuantityValue &&
            sleepQualityValue == source.sleepQualityValue &&
            loadValue == source.loadValue &&
            futureLoadValue == source.futureLoadValue &&
            targetSleepQuantity == source.targetSleepQuantity
    }
}
