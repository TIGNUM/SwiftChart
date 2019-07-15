//
//  GoodToKnowCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct GoodToKnowCellViewModel: DailyBriefBucket {
    var fact: String?
    var image: URL?
    var domainModel: QDMDailyBriefBucket?
}
