//
//  UpcomingEventHandler.swift
//  Intent
//
//  Created by Javier Sanz Rozalén on 14.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class UpcomingEventHandler: NSObject, UpcomingEventIntentHandling {
    
    func handle(intent: UpcomingEventIntent, completion: @escaping (UpcomingEventIntentResponse) -> Void) {
        if let events: [ExtensionModel.UpcomingEvent] = ExtensionUserDefaults.object(for: .siri, key: .upcomingEvents) {
            if events.count > 0 {
                let response = responseForOneEvent(events.first)
                completion(response)
            } else {
                let response = UpcomingEventIntentResponse(code: .noUpcomingEvents, userActivity: nil)
                response.userActivity = NSUserActivity.activity(for: .eventsList)
                completion(response)
            }
        }
        completion(UpcomingEventIntentResponse(code: .failure, userActivity: nil))
    }
}

// MARK: - Private

private extension UpcomingEventHandler {
    
    func responseForOneEvent(_ event: ExtensionModel.UpcomingEvent?) -> UpcomingEventIntentResponse {
        let title = event?.eventName ?? ""
        let startDate = event?.startDate
        let duration = startDate?.eventsDate() ?? ""
        let response = UpcomingEventIntentResponse.successOneEvent(firstEventTitle: title, firstEventStartDate: duration)
        response.firstEventDuration = startDate?.durationDate(until: event?.endDate)
        response.userActivity = NSUserActivity.activity(for: .event, arguments: [event?.localID ?? ""])
        return response
    }
}

// MARK: - Date

fileprivate extension Date {
    
    func eventsDate() -> String {
        // Format like: Wed, Feb 6
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        return dateFormatter.string(from: self)
    }
    
    func durationDate(until endDate: Date?) -> String {
        // Format like: 9:30 AM to 10:30 PM
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a"
        if let endDate = endDate {
            return "\(dateFormatter.string(from: self)) to \(dateFormatter.string(from: endDate))"
        }
        return "\(dateFormatter.string(from: self))"
    }
}
