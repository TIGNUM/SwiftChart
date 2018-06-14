//
//  Filters.swift
//  QOT
//
//  Created by Sam Wyndham on 22.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

extension Results where Element: CalendarEvent {
    func filter(externalIdentifier: String?) -> LazyFilterCollection<Results<T>> {
        return filter { $0.calendarItemExternalIdentifier == externalIdentifier }
    }

    func filter(ekEvent: EKEvent!) -> LazyFilterCollection<Results<T>> {
        return filter {
            $0.calendarItemExternalIdentifier == ekEvent.calendarItemExternalIdentifier && $0.startDate == ekEvent.startDate
        }
    }
}
