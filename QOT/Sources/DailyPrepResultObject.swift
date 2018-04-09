//
//  DailyPrepResultObject.swift
//  QOT
//
//  Created by Sam Wyndham on 14/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class DailyPrepResultObject: SyncableObject {

    @objc private(set) dynamic var isoDate: String = "" // A date such as Eg. 2018-01-31

    @objc private(set) dynamic var title: String = ""

    @objc private(set) dynamic var feedback: String?

    let answers = List<DailyPrepAnswerObject>()

    convenience init(date: ISODate, title: String, answers: [DailyPrepAnswerObject]) {
        self.init()

        self.isoDate = date.string
        self.title = title
        self.answers.append(objectsIn: answers)
    }

    var dateComponants: (year: Int, month: Int, day: Int)? {
        let componants = isoDate.components(separatedBy: "-").compactMap { Int($0) }
        guard componants.count == 3 else { return nil }

        return (year: componants[0], month: componants[1], day: componants[2])
    }
}

extension DailyPrepResultObject: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .dailyPrepResult
    }

    func setData(_ data: DailyPrepResultIntermediary, objectStore: ObjectStore) throws {
        isoDate = data.isoDate
        feedback = data.feedback

        let newAnswers = data.answers.map {
            return DailyPrepAnswerObject(title: $0.title, value: $0.value, colorState: $0.colorState)
        }
        objectStore.delete(answers)
        answers.append(objectsIn: newAnswers)
    }
}
