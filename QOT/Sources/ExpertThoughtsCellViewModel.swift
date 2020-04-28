//
//  ExpertThoughtsCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 27.04.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ExpertThoughtsCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var title: String?
    var subtitle: String?
    var description: String?
    var audioDuration: Double?
    var audioLink: URL?
    var remoteID: Int?
    var durationString: String?

    // MARK: - Init
    init(title: String?,
                  subtitle: String?,
                  description: String?,
                  audioDuration: Double?,
                  audioLink: URL?,
                  format: ContentFormat,
                  remoteID: Int?,
                  durationString: String?,
                  domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.audioDuration = audioDuration
        self.audioLink = audioLink
        self.remoteID = remoteID
        self.durationString = durationString
        super.init(domainModel)
    }
}
