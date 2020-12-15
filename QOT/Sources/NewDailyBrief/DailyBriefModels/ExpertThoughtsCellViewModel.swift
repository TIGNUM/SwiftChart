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
    var subtitle: String?
    var description: String?
    var audioDuration: Double?
    var audioLink: URL?
    var remoteID: Int?
    var durationString: String?
    var audioTitle: String?
    var name: String?
    var format: ContentFormat

    // MARK: - Init
    init(title: String?,
         subtitle: String?,
         description: String?,
         image: String?,
         audioTitle: String?,
         audioDuration: Double?,
         audioLink: URL?,
         format: ContentFormat,
         remoteID: Int?,
         durationString: String?,
         name: String?,
         domainModel: QDMDailyBriefBucket?) {
        self.subtitle = subtitle
        self.audioTitle = audioTitle
        self.description = description
        self.audioDuration = audioDuration
        self.audioLink = audioLink
        self.remoteID = remoteID
        self.durationString = durationString
        self.name = name
        self.format = format
        super.init(domainModel, caption: title, title: name, body: description, image: image)
    }
}
