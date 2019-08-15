//
//  QDMTermData+Ext.swift
//  QOT
//
//  Created by karmic on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMTermData {
    func triggerType() -> SolveTriggerType? {
        switch name {
        case "solve-trigger-mindsetshifter":
            return .midsetShifter
        case "solve-trigger-tobevisiongenerator":
            return .tbvGenerator
        case "solve-trigger-3drecoveryplanner":
            return .recoveryPlaner
        default:
            return nil

        }
    }
}
