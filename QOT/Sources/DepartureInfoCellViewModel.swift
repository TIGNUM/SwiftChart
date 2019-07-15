//
//  DepartureInfoCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct DepartureInfoCellViewModel: DailyBriefBucket {
    var text: String?
    var image: String?
    var link: String?
    var domainModel: QDMDailyBriefBucket?
}
