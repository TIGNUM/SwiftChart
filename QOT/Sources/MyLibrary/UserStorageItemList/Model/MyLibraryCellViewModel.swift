//
//  MyLibraryBookmarksModel.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct MyLibraryCellViewModel: Equatable {
    enum CellType {
        case VIDEO
        case AUDIO
        case ARTICLE
        case DOWNLOAD
        case NOTE
    }

    enum DownloadStatus {
        case none
        case waiting
        case downloading
        case downloaded
    }

    let cellType: CellType
    let title: String
    let description: String
    let duration: String
    let icon: UIImage?
    let previewURL: URL?
    let type: UserStorageType
    let mediaType: UserStorageMediaType
    let downloadStatus: DownloadStatus

    let identifier: String
    let remoteId: Int
    let mediaURL: URL?

    static func == (lhs: MyLibraryCellViewModel, rhs: MyLibraryCellViewModel) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.duration == rhs.duration &&
            lhs.icon == rhs.icon &&
            lhs.previewURL == rhs.previewURL &&
            lhs.mediaType == rhs.mediaType &&
            lhs.remoteId == rhs.remoteId
    }
}
