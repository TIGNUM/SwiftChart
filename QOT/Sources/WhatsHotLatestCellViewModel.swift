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

struct WhatsHotLatestCellViewModel: DailyBriefBucket {
    var title: String?
    var image: URL?
    var author: String?
    var publisheDate: Date?
    var timeToRead: Int?
    var isNew: Bool
    var remoteID: Int?
    var domainModel: QDMDailyBriefBucket?
}
