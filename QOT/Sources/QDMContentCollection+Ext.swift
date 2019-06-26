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
    func getCategories(_ completion: @escaping (([QDMContentCategory]?) -> Void)) {
        let relatedIds = relatedContentIDsPrepareAll ?? []
        qot_dal.ContentService.main.getContentCategoriesByIds(relatedIds, completion)
    }
}

extension QDMContentCollection {
    var relatedContentIDsPrepareDefault: [Int] {
        return relatedContentList.filter { $0.type == "PREPARE_DEFAULT" }.compactMap { $0.contentID }
    }

    var relatedContentIDsPrepareAll: [Int] {
        return relatedContentList.filter { $0.type == "PREPARE_DEFAULT" || $0.type == "PREPARE_OPTIONAL" }.compactMap { $0.contentID }
    }

    func isRelatedDefault(_ contentId: Int) -> Bool {
        return false// emoteID == contentId && type = "PREPARE_DEFAULT"
    }
}

extension QDMContentCollection {
    var durationString: String {
        get {
            if hasVideoOnly == true {
                let durations = contentItems.compactMap { $0.valueDuration }
                let total = Int(durations.reduce(0) { ($0/60) + ($1/60) })
                return R.string.localized.learnContentDurationVideo(String(total))
            } else if isFoundation == true {
                let videoItem = contentItems.filter { $0.format == ContentFormat.video }.first
                return videoItem?.durationString ?? ""
            }
            return R.string.localized.learnContentListViewMinutesLabel(String(max(minutesToRead, 1)))
        }
    }

    var minutesToRead: Int {
        get {
            return contentItems.reduce(0, { (sum, item) -> Int in
                switch item.format {
                case .video, .audio, .image, .pdf: return sum
                default: return sum + Int(item.valueDuration ?? 0)
                }
            }) / 60
        }
    }

    var hasVideoOnly: Bool {
        get { return contentItems.filter { $0.format == ContentFormat.video }.count == contentItems.count }
    }

    var isWhatsHot: Bool {
        get { return section == ContentSection.WhatsHot }
    }

    var isFoundation: Bool {
        get { return categoryIDs.contains(qot_dal.ContentCategory.PerformanceFoundation.rawValue) }
    }

    var hasAudioItems: Bool {
        get { return !contentItems.filter { $0.tabs.contains(ContentFormat.audio.rawValue) }.isEmpty }
    }
}
