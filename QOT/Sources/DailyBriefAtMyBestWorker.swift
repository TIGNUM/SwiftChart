//
//  DailyBriefAtMyBestWorker.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 06/11/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyBriefAtMyBestWorker {
    func storedText(_ text: String, today: Date = Date()) -> String {
        let userDefaultStamp = UserDefault.myBestDate.object
        UserDefault.myBestDate.setObject(today)

        var shouldSetText = false
        if let dateStamp = userDefaultStamp as? Date {
            if dateStamp.dayOfMonth != today.dayOfMonth {
                shouldSetText = true
            }
        } else {
            shouldSetText = true
        }
        if shouldSetText {
            UserDefault.myBestText.setStringValue(value: text)
        }
        
        return UserDefault.myBestText.stringValue ?? text
    }
}
