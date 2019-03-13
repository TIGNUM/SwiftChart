//
//  IntentHandler+AppEvents.swift
//  Intent
//
//  Created by Javier Sanz Rozalén on 01.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Intents

@available(iOSApplicationExtension 12.0, *)
extension NSObjectProtocol {

    private func intentEventKey(for intent: INIntent) -> String? {
        switch intent {
        case is ReadVisionIntent:
            return ExtensionUserDefaults.toBeVision.rawValue
        case is WhatsHotIntent:
            return ExtensionUserDefaults.whatsHot.rawValue
        case is UpcomingEventIntent:
            return ExtensionUserDefaults.upcomingEvents.rawValue
        case is DailyPrepIntent:
            return ExtensionUserDefaults.dailyPrep.rawValue
        default:
            return nil
        }
    }

    func track(_ intent: INIntent) {
        guard let key = intentEventKey(for: intent) else { return }
        let newEvent = SiriEventsModel.Event(date: Date(), key: key)
        if var accumulatedEvents: SiriEventsModel = ExtensionUserDefaults.object(for: .siri, key: .siriAppEvents) {
            accumulatedEvents.events.append(newEvent)
            ExtensionUserDefaults.siriAppEvents.clearWidgetObject()
            ExtensionUserDefaults.set(accumulatedEvents, for: .siriAppEvents)
        } else {
            let newAccumulatedEvents = SiriEventsModel(events: [newEvent])
            ExtensionUserDefaults.set(newAccumulatedEvents, for: .siriAppEvents)
        }
    }
}
