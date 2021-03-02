//
//  ContentService+Ext.swift
//  QOT
//
//  Created by karmic on 18.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension ContentService {
    func questionId(_ contentItem: QDMContentItem) -> Int {
        if contentItem.valueText.contains(Prepare.Key.perceived.tag) {
            return Prepare.Key.perceived.questionID
        }
        if contentItem.valueText.contains(Prepare.Key.feel.tag) {
            return Prepare.Key.feel.questionID
        }
        if contentItem.valueText.contains(Prepare.Key.know.tag) {
            return Prepare.Key.know.questionID
        }
        if contentItem.valueText.contains(Prepare.Key.benefits.tag) {
            return Prepare.Key.benefits.questionID
        }
        return .zero
    }
}
