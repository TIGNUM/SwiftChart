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
        var mediaURL: URL? {
            if let download = mediaItem?.userStorages?.filter({ (storage) -> Bool in
                storage.userStorageType == .DOWNLOAD
            }).first, let downloadURL = URL(string: download.mediaPath() ?? "") {
                return downloadURL
            }
            return URL(string: mediaItem?.valueMediaURL ?? "")
        }
        var duration: Double {
            return mediaItem?.valueDuration ?? 0
        }

        var durationString: String {
            return mediaItem?.durationString ?? ""
        }
    }
}
