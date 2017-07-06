//
//  ContentItemIntermediary.swift
//  Pods
//
//  Created by Sam Wyndham on 07/04/2017.
//
//

import Foundation
import Freddy

struct ContentItemIntermediary {
    let sortOrder: Int
    let secondsRequired: Int
    let format: String
    let viewed: Bool
    let searchTags: String
    let tabs: String
    let layoutInfo: String?
    let contentID: Int
    let relatedContent: [ContentRelationIntermediary]

    // Value
    let valueText: String?
    let valueDescription: String?
    let valueImageURL: String?
    let valueMediaURL: String?
    let valueDuration: Double?
    let valueWavformData: String?
}

// MARK: - Parser

extension ContentItemIntermediary: JSONDecodable {

    init(json: JSON) throws {
        self.sortOrder = try json.getItemValue(at: .sortOrder)
        self.secondsRequired = try json.getItemValue(at: .secondsRequired)
        self.format = try json.getItemValue(at: .format)
        self.viewed = try json.getItemValue(at: .viewed)
        self.searchTags = ContentItemIntermediary.commaSeperatedStringFromArray(in: json, at: .searchTags)
        self.tabs = ContentItemIntermediary.commaSeperatedStringFromArray(in: json, at: .tabs)
        self.layoutInfo = try json.serializeString(at: .layoutInfo)
        self.contentID = try json.getItemValue(at: .contentId)
        self.relatedContent = try json.getArray(at: .relatedContent)

        let valueJSON = try json.json(at: .value)
        self.valueText = try valueJSON.getItemValue(at: .text)
        self.valueDescription = try valueJSON.getItemValue(at: .description)
        self.valueImageURL = try valueJSON.getItemValue(at: .imageURL)
        self.valueMediaURL = try valueJSON.getItemValue(at: .mediaURL)
        self.valueDuration = try valueJSON.getItemValue(at: .duration)
        self.valueWavformData = try valueJSON.serializeString(at: .waveformData)
    }

    private static func commaSeperatedStringFromArray(in json: JSON, at key: JsonKey) -> String {
        do {
            return try (json.getArray(at: key) as [String]).joined(separator: ",")
        } catch {
            return ""
        }
    }
}
