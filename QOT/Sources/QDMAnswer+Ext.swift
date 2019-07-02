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
    func targetId(_ type: TargetType) -> Int? {
        return decisions.first(where: { $0.targetType == type.rawValue })?.targetTypeId
    }
}
