//
//  Range+MakeOneDay.swift
//  QOT
//
//  Created by karmic on 17.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension Range where Bound == Date {

    static func makeOneDay(daysFromNow: Int) -> Range<Date> {
        let calendar = Calendar.current
        var components = DateComponents()

        components.day = daysFromNow
        let date = calendar.date(byAdding: components, to: Date())!
        let start = calendar.startOfDay(for: date)

        components.day = 1
        let end = calendar.date(byAdding: components, to: start)!

        return start..<end
    }
}
