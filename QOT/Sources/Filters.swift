//
//  Filters.swift
//  QOT
//
//  Created by Sam Wyndham on 22.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

extension Results where Element: CalendarEvent {

    func filter(title: String?, startDate: Date, endDate: Date) -> LazyFilterCollection<Results<T>> {
        return filter { $0.title == title && $0.startDate == startDate && $0.endDate == endDate }
    }
}
