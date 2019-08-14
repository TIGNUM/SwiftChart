//
//  LeaderWisdomCellViewModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 02.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class LeaderWisdomCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var title: String?
    var subtitle: String?
    var description: String?
    var audioDuration: Double?
    var audioLink: URL?
    var videoTitle: String?
    var videoDuration: Double?
    var videoThumbnail: URL?
    var format: ContentFormat
    var remoteID: Int?
    var durationString: String?

    // MARK: - Init
    init(title: String?,
                  subtitle: String?,
                  description: String?,
                  audioDuration: Double?,
                  audioLink: URL?,
                  videoTitle: String?,
                  videoDuration: Double?,
                  videoThumbnail: URL?,
                  format: ContentFormat,
                  remoteID: Int?,
                  durationString: String?,
                  domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.audioDuration = audioDuration
        self.audioLink = audioLink
        self.videoTitle = videoTitle
        self.videoDuration = videoDuration
        self.videoThumbnail = videoThumbnail
        self.format = format
        self.remoteID = remoteID
        self.durationString = durationString
        super.init(domainModel)
    }
}
