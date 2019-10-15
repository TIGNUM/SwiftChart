//
//  StrategyListModel.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct Strategy {

    struct Item {
        let remoteID: Int
        let categoryTitle: String
        let title: String
        let imageURL: URL?
        let mediaItem: QDMContentItem?
        let contentItems: [QDMContentItem]?
        let valueDuration: Int

        var mediaURL: URL? {
            if let download = mediaItem?.userStorages?.filter({ (storage) -> Bool in
                storage.userStorageType == .DOWNLOAD
            }).first, let downloadURL = URL(string: download.mediaPath() ?? "") {
                return downloadURL
            }
            return URL(string: mediaItem?.valueMediaURL ?? "")
        }

        var duration: Double {
            return Double(valueDuration)
        }

        var durationString: String {
            guard let mediaItem = mediaItem else { return "" }

            if mediaItem.format == .audio,
                let audioTextItems = contentItems?.filter({ $0.format == .paragraph || $0.format == .prepare }),
                !audioTextItems.isEmpty {
                return audioTextDurationString()
            } else {
                return mediaItem.durationString
            }
        }

        private func audioTextDurationString() -> String {
            let min = String(format: "%.0f", Double(valueDuration) / 60)
            return String(format: AppTextService.get(AppTextKey.pdf_list_title_duration), min)
        }
    }
}
