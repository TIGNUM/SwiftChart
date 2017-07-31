//
//  SyncDescription.swift
//  QOT
//
//  Created by Sam Wyndham on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

let ContentCategoryDown = SyncDescription<ContentCategoryData, ContentCategory>(syncType: .contentCategoryDown)
let ContentCollectionDown = SyncDescription<ContentCollectionData, ContentCollection>(syncType: .contentCollectionDown)
let ContentItemDown = SyncDescription<ContentItemIntermediary, ContentItem>(syncType: .contentItemDown)
let UserDown = SyncDescription<UserIntermediary, User>(syncType: .userDown)
let PageDown = SyncDescription<PageIntermediary, Page>(syncType: .pageDown)
let QuestionDown = SyncDescription<QuestionIntermediary, Question>(syncType: .questionDown)
let DataPointDown = SyncDescription<MyStatisticsIntermediary, MyStatistics>(syncType: .dataPointDown)
let SystemSettingDown = SyncDescription<SystemSettingIntermediary, SystemSetting>(syncType: .systemSettingDown)
let UserSettingDown = SyncDescription<UserSettingIntermediary, UserSetting>(syncType: .userSettingDown)
let UserChoiceDown = SyncDescription<UserChoiceIntermediary, UserChoice>(syncType: .userChoiceDown)
let PartnerDown = SyncDescription<PartnerIntermediary, Partner>(syncType: .partnerDown)
let MyToBeVisionDown = SyncDescription<MyToBeVisionIntermediary, MyToBeVision>(syncType: .myToBeVisionDown)

struct SyncDescription<Intermediary, Persistable> where Intermediary: DownSyncIntermediary {
    let syncType: SyncType
}
