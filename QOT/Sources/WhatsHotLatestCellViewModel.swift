//
//  WhatsHotLatestViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DailyBriefBucket {
    var domainModel: QDMDailyBriefBucket? { get set }
}

final class WhatsHotLatestCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var bucketTitle: String?
    var title: String
    let image: URL?
    let author: String
    let publisheDate: Date
    let timeToRead: Int
    let isNew: Bool
    let remoteID: Int

    // MARK: - Init
    init(bucketTitle: String?,
                  title: String,
                  image: URL?,
                  author: String,
                  publisheDate: Date,
                  timeToRead: Int,
                  isNew: Bool,
                  remoteID: Int,
                  domainModel: QDMDailyBriefBucket?) {
        self.bucketTitle = bucketTitle
        self.title = title
        self.image = image
        self.author = author
        self.publisheDate = publisheDate
        self.timeToRead = timeToRead
        self.isNew = isNew
        self.remoteID = remoteID
        super.init(domainModel)
    }
}
