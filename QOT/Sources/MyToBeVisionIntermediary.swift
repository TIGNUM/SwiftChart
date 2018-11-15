//
//  MyToBeVisionIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 28.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct MyToBeVisionIntermediary: DownSyncIntermediary {

    var headline: String?
    var subHeadline: String?
    var text: String?
    var validFrom: Date
    var validTo: Date?
    var workTags: [String] = []
    var homeTags: [String] = []
    var profileImages: [MediaResourceIntermediary] = []

    init(json: JSON) throws {
        let images = try json.getArray(at: JsonKey.images.rawValue)
        for mediaResource in images {
            profileImages.append(try MediaResourceIntermediary(json: mediaResource))
        }
        if profileImages.count == 0 {
            profileImages.append(MediaResourceIntermediary.intermediary(for: .toBeVision))
        }
        headline = try json.getItemValue(at: .title)
        subHeadline = try json.getItemValue(at: .shortDescription)
        text = try json.getItemValue(at: .description)
        validFrom = (try json.getDate(at: .validFrom) as Date?) ?? Date()
        validTo = try json.getDate(at: .validUntil)
        let tags = try json.getArray(at: .keywordTags, fallback: [])
        for tagModel in tags {
            let type = try tagModel.getItemValue(at: .key, fallback: "")
            switch JsonKey.init(rawValue: type) {
            case .home?:
                homeTags = try tagModel.getArray(at: .tags)
            case .work?:
                workTags = try tagModel.getArray(at: .tags)
            default:
                continue
            }
        }
    }
}
