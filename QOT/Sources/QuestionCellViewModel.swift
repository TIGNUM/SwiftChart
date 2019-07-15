//
//  QuestionCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct QuestionCellViewModel: DailyBriefBucket {
    var text: String?
    var domainModel: QDMDailyBriefBucket?
}
