//
//  SettingIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct SystemSettingIntermediary {

    let sortOrder: Int
    let type: String
    var component: String
    var key: String
    var displayName: String
    var settingDescription: String
    var pageIDs: String
    var isDefault: Bool
    var value: SettingValue?
    var textValue: String
}

extension SystemSettingIntermediary: DownSyncIntermediary {

    init(json: JSON) throws {
        let format: SettingFormat = try json.decode(at: JsonKey.format.rawValue)
        self.sortOrder = try json.getItemValue(at: .sortOrder, fallback: 0)
        self.type = try json.getItemValue(at: .type, fallback: "")
        self.component = try json.getItemValue(at: .component, fallback: "")
        self.key = try json.getItemValue(at: .key, fallback: "")
        self.textValue = try json.getItemValue(at: .textValue, fallback: "")
        self.displayName = try json.getItemValue(at: .displayName, fallback: "")
        self.settingDescription = try json.getItemValue(at: .description, fallback: "")
        self.isDefault = try json.getItemValue(at: .default, fallback: true)

        if let valueJSON = try json.getArray(at: format.valueKey.rawValue).first {
            self.value = try SettingValue(json: valueJSON, format: format)
        }

        let pageIDs: [Int] = try json.getArray(at: .pageIds, fallback: [])
        self.pageIDs = pageIDs.map { String($0) }.joined(separator: ",")
    }
}

// MARK: Private helpers

private extension SettingFormat {

    var valueKey: JsonKey {
        switch self {
        case .boolean:
            return .settingBoolValueDtos
        case .int:
            return .settingLongValueDtos
        case .occurrence:
            return .settingOccurrenceValueDtos
        case .text:
            return .settingTextValueDtos
        }
    }
}
