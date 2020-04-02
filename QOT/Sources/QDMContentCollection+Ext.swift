//
//  QDMContentCollection+Ext.swift
//  QOT
//
//  Created by karmic on 18.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMContentCollection {
    var relatedContentIDsPrepareDefault: [Int] {
        return relatedContentList.filter { $0.type == "PREPARE_DEFAULT" }.compactMap { $0.contentID }
    }

    var relatedContentItemIdsPrepareDefault: [Int] {
        return relatedContentList.filter { $0.type == "PREPARE_DEFAULT" }.compactMap { $0.contentItemID }
    }

    var relatedContentIDsPrepareAll: [Int] {
        return relatedContentList.filter { $0.type == "PREPARE_DEFAULT" || $0.type == "PREPARE_OPTIONAL" }
        .compactMap { $0.contentID }
    }

    var relatedContentItemIDsPrepareAll: [Int] {
        return relatedContentList.filter { $0.type == "PREPARE_DEFAULT" || $0.type == "PREPARE_OPTIONAL" }
            .compactMap { $0.contentItemID }
    }

    var exclusiveContentIds: [Int] {
        return relatedContentList.filter { $0.type == "EXCLUSIVE_CONTENT" }.compactMap { $0.contentID }
    }

    var suggestedContentIds: [Int] {
        return relatedContentList.filter { $0.type == "RELATED_STRATEGY" }.compactMap { $0.contentID }
    }
}

extension QDMContentCollection {
    var durationString: String {
        if hasVideoOnly == true {
            let durations = contentItems.compactMap { $0.valueDuration }
            let total = String(Int(durations.reduce(0) { ($0/60) + ($1/60) }))
            return String(format: AppTextService.get(.generic_content_section_item_label_video), total)
        } else if hasAudioItems == true {

        } else if isFoundation == true {
            let videoItem = contentItems.filter { $0.format == ContentFormat.video }.first
            return videoItem?.durationString ?? ""
        }
        return String(format: AppTextService.get(.generic_content_section_item_label_read), String(max(minutesToRead, 1)))
    }

    var minutesToRead: Int {
        return contentItems.reduce(0, { (sum, item) -> Int in
            switch item.format {
            case .video, .audio, .image, .pdf: return sum
            default: return sum + Int(item.valueDuration ?? 0)
            }
        }) / 60
    }

    var hasVideoOnly: Bool {
        return contentItems.filter { $0.format == ContentFormat.video }.count == contentItems.count
    }

    var isWhatsHot: Bool {
        return section == ContentSection.WhatsHot
    }

    var isFoundation: Bool {
        return categoryIDs.contains(ContentCategory.PerformanceFoundation.rawValue)
    }

    var hasAudioItems: Bool {
        return !contentItems.filter { $0.tabs.contains(ContentFormat.audio.rawValue) }.isEmpty
    }
}

extension QDMContentCollection {
    func triggerType() -> SolveTriggerType? {
        var triggerType: SolveTriggerType?
        searchTagsDetailed.forEach { (termData) in
            triggerType = termData.triggerType()
        }
        return triggerType
    }
}
