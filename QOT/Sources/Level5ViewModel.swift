//
//  Level5ViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 29.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class Level5ViewModel: BaseDailyBriefViewModel {

    struct LevelDetail {
        let levelTitle: String?
        let levelContent: String?
    }

    internal init(title: String?, intro: String?,
                  question: String?,
                  youRatedPart1: String?,
                  youRatedPart2: String?,
                  comeBackText: String?,
                  levelMessages: [LevelDetail],
                  confirmationMessage: String?,
                  domainModel: QDMDailyBriefBucket) {
        self.title = title
        self.intro = intro
        self.question = question
        self.youRatedPart1 = youRatedPart1
        self.youRatedPart2 = youRatedPart2
        self.comeBackText = comeBackText
        self.levelMessages = levelMessages
        self.confirmationMessage = confirmationMessage
        super.init(domainModel)
    }

    var title: String?
    var intro: String?
    var question: String?
    var youRatedPart1: String?
    var youRatedPart2: String?
    var levelTitle: String?
    var levelContent: String?
    var comeBackText: String?
    var currentLevel: Int?
    var confirmationMessage: String?
    var levelMessages: [LevelDetail]

}
