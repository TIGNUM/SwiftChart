//
//  ThoughtsCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct ThoughtsCellViewModel: DailyBriefBucket {
    var thought: String?
    var author: String?
    var domainModel: QDMDailyBriefBucket?
}
