//
//  DailyPrepIntentHandler.swift
//  Intent
//
//  Created by Javier Sanz Rozalén on 19.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyPrepIntentHandler: NSObject, DailyPrepIntentHandling {

    func handle(intent: DailyPrepIntent, completion: @escaping (DailyPrepIntentResponse) -> Void) {
        if
            let dailyPrepResult: ExtensionModel.DailyPrep = ExtensionUserDefaults.object(for: .siri, key: .dailyPrep),
            dailyPrepResult.displayDate.is24hoursOld == false {
            let response = completedResponse(for: dailyPrepResult)
            completion(response)
            return
        }
        completion(incompletedResponse())
    }
}

// MARK: - Private

private extension DailyPrepIntentHandler {
    
    func completedResponse(for dailyPrepResult: ExtensionModel.DailyPrep) -> DailyPrepIntentResponse {
        let response = DailyPrepIntentResponse.success(feedback: dailyPrepResult.feedback ?? "")
        response.loadValue = NSNumber(value: dailyPrepResult.loadValue)
        response.recoveryValue = NSNumber(value: dailyPrepResult.recoveryValue)
        return response
    }
    
    func incompletedResponse() -> DailyPrepIntentResponse {
        let response = DailyPrepIntentResponse(code: .notCompleted, userActivity: nil)
        response.userActivity = NSUserActivity.activity(for: .dailyPrep)
        return response
    }
}
