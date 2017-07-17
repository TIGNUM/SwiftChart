//
//  SettingsValueEnum.swift
//  QOT
//
//  Created by Sam Wyndham on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

enum SettingValue {
    case text(String)
    case bool(Bool)
    case int(Int, min: Int?, max: Int?)
    case occurrence(from: Date?, to: Date?, workingDays: Bool, weekend: Bool, publicHolidays: Bool, vacation: Bool)
    case invalid

    init(setting: SettingValueObject) {
        guard let format = SettingFormat(rawValue: setting.format) else {
            self = .invalid
            return
        }

        switch format {
        case .text:
            self = setting.text.map { .text($0) } ?? .invalid
        case .boolean:
            self = .bool(setting.bool)
        case .int:
            if let int = setting.int {
                self = .int(int, min: setting.min, max: setting.max)
            } else {
                self = .invalid
            }
        case .occurrence:
            self = .occurrence(from: setting.from,
                               to: setting.to,
                               workingDays: setting.workingDays,
                               weekend: setting.weekend,
                               publicHolidays: setting.publicHolidays,
                               vacation: setting.vacation)
        }
    }

    var format: SettingFormat? {
        switch self {
        case .text:
            return .text
        case .bool:
            return .boolean
        case .int:
            return .int
        case .occurrence:
            return .occurrence
        default:
            return nil
        }
    }
}

extension SettingValue {

    init(json: JSON, format: SettingFormat) throws {
        switch format {
        case .text:
            self = .text(try json.getItemValue(at: .value, fallback: ""))
        case .boolean:
            self = .bool(try json.getItemValue(at: .value, fallback: false))
        case .int:
            self = .int(try json.getItemValue(at: .value),
                        min: try json.getItemValue(at: .min),
                        max: try json.getItemValue(at: .max))
        case .occurrence:
            self = .occurrence(from: try json.getDate(at: .fromDate),
                               to: try json.getDate(at: .untilDate),
                               workingDays: try json.getItemValue(at: .workingDays, fallback: false),
                               weekend: try json.getItemValue(at: .weekend, fallback: false),
                               publicHolidays: try json.getItemValue(at: .publicHolidays, fallback: false),
                               vacation: try json.getItemValue(at: .vacation, fallback: true))
        }
    }
}
