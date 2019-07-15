//
//  FeastCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct FeastCellViewModel: DailyBriefBucket {
    var image: String?
    var remoteID: Int?
    var domainModel: QDMDailyBriefBucket?
}
