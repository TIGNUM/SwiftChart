//
//  DTPresentationModel.swift
//  QOT
//
//  Created by karmic on 08.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct DTPresentationModel {
    var question: QDMQuestion?
    var titleToUpdate: String?
    var answerFilter: String?
    var tbv: QDMToBeVision?

    init(question: QDMQuestion?, titleToUpdate: String?, answerFilter: String?, tbv: QDMToBeVision?) {
        self.question = question
        self.titleToUpdate = titleToUpdate
        self.answerFilter = answerFilter
        self.tbv = tbv
    }

    init(question: QDMQuestion?) {
        self.question = question
        self.titleToUpdate = nil
        self.answerFilter = nil
        self.tbv = nil
    }
}
