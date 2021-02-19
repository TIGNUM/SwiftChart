//
//  WhatsHotLatestViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import DifferenceKit

final class WhatsHotLatestCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var bucketTitle: String?
    let author: String
    let publisheDate: Date
    let timeToRead: String
    let isNew: Bool
    let remoteID: Int

    // MARK: - Init
    init(bucketTitle: String?,
         title: String,
         image: String?,
         author: String,
         publisheDate: Date,
         timeToRead: String,
         isNew: Bool,
         remoteID: Int,
         domainModel: QDMDailyBriefBucket?) {
        self.bucketTitle = bucketTitle
        self.author = author
        self.publisheDate = publisheDate
        self.timeToRead = timeToRead
        self.isNew = isNew
        self.remoteID = remoteID
        super.init(domainModel, title: title, image: image)
        setupStrings()
    }

    func setupStrings() {
        let dateAndDurationText = DateFormatter.whatsHotBucket.string(from: publisheDate) + " | " + timeToRead
        caption = AppTextService.get(.daily_brief_section_whats_hot_title_new)
        body = dateAndDurationText
    }
}
