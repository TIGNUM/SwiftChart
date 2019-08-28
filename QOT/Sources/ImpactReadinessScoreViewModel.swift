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
    var sleepQualityValue: Double?
    var loadValue: Double?
    var futureLoadValue: Double?
    var targetSleepQuality: Double?
    var sleepQualityReference: Double?
    var loadReference: Double?
    var futureLoadReference: Double?
    var title: String?
    var subTitle: String?
    var impactDataModels: [ImpactDataViewModel]?
    var type = ImpactReadinessType.DAILY_CHECK_IN
    struct ImpactDataViewModel {
        var title: String?
        var subTitle: String?
    }
    init(howYouFeelToday: String?,
         asteriskText: String?,
         sleepQuantityValue: Double?,
         sleepQualityValue: Double?,
         loadValue: Double?,
         futureLoadValue: Double?,
         targetSleepQuality: Double?,
         sleepQualityReference: Double?,
         loadReference: Double?,
         futureLoadReference: Double?,
         impactDataModels: [ImpactDataViewModel]?,
         domainModel: QDMDailyBriefBucket,
         _ subIdentifier: String? = "") {

        self.howYouFeelToday = howYouFeelToday
        self.asteriskText = asteriskText

        self.sleepQuantityValue = sleepQuantityValue
        self.sleepQualityValue = sleepQualityValue

        self.targetSleepQuality = targetSleepQuality
        self.sleepQualityReference = sleepQualityReference

        self.loadValue = loadValue
        self.futureLoadValue = futureLoadValue

        self.loadReference = loadReference
        self.futureLoadReference = futureLoadReference
        
        self.impactDataModels = impactDataModels
        super.init(domainModel, subIdentifier)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? ImpactReadinessScoreViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            howYouFeelToday == source.howYouFeelToday &&
            sleepQuantityValue == source.sleepQuantityValue &&
            sleepQualityValue == source.sleepQualityValue &&
            loadValue == source.loadValue &&
            futureLoadValue == source.futureLoadValue &&
            targetSleepQuality == source.targetSleepQuality &&
            sleepQualityReference == source.sleepQualityReference &&
            loadReference == source.loadReference &&
            futureLoadReference == source.futureLoadReference
    }
}
