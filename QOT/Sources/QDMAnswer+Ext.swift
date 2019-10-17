//
//  QDMAnswer+Ext.swift
//  QOT
//
//  Created by karmic on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMAnswer {
    typealias AnswerId = Int
}

extension QDMAnswer.AnswerId {
    static let TBV_GO_TO_ARTICLE_ID = 101112
    static let TBV_WATCH_VIDEO_ID = 101113
    static let PREPARE_CRITICAL_EVENT = 101132
    static let PREPARE_DAILY_EVENT = 101133
}

extension QDMAnswer {
    func targetId(_ type: TargetType) -> Int? {
        return decisions.first(where: { $0.targetType == type.rawValue })?.targetTypeId
    }
}
