//
//  DailyPrepAnswerObject.swift
//  QOT
//
//  Created by Sam Wyndham on 14/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import RealmSwift

final class DailyPrepAnswerObject: Object {

    @objc private(set) dynamic var value: Int = 0

    @objc private(set) dynamic var colorState: String?

    @objc private(set) dynamic var title: String = ""

    convenience init(title: String, value: Int, colorState: String? = nil) {
        self.init()

        self.title = title
        self.value = value
        self.colorState = colorState
    }
}

extension DailyPrepAnswerObject {

    var color: UIColor {
        guard let colorState = colorState else { return .white90 }

        switch colorState {
        case "CRITICAL":
            return .cherryRed
        case "LOW":
            return .gray
        default:
            return .white90
        }
    }
}
