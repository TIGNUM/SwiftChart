//
//  Filters.swift
//  QOT
//
//  Created by Sam Wyndham on 22.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

extension Results where Element: CalendarEvent {
    func filter(externalIdentifier: String?) -> LazyFilterCollection<Results<Element>> {
        return filter { $0.calendarItemExternalIdentifier == externalIdentifier }
    }

    func filter(ekEvent: EKEvent!) -> LazyFilterCollection<Results<Element>> {
        return filter {
            return $0.matches(event: ekEvent)
        }
    }
}
