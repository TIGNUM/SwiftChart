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

    var intro: String?
    var question: String?
    var youRatedPart1: String?
    var youRatedPart2: String?
    var levelTitle: String?
    var levelContent: String?
    var comeBackText: String?
    var currentLevel: Int?
    var confirmationMessage: String?
    var latestSavedValue: Int?
    var levelMessages: [LevelDetail]

    internal init(caption: String?,
                  intro: String?,
                  question: String?,
                  image: String?,
                  youRatedPart1: String?,
                  youRatedPart2: String?,
                  comeBackText: String?,
                  levelMessages: [LevelDetail],
                  confirmationMessage: String?,
                  latestSavedValue: Int?,
                  domainModel: QDMDailyBriefBucket) {
        self.intro = intro
        self.question = question
        self.youRatedPart1 = youRatedPart1
        self.youRatedPart2 = youRatedPart2
        self.comeBackText = comeBackText
        self.levelMessages = levelMessages
        self.confirmationMessage = confirmationMessage
        self.latestSavedValue = latestSavedValue
        super.init(domainModel, caption: caption, image: image)
        setupStrings()
    }

    func setupStrings() {
            title = levelMessages[domainModel?.currentGetToLevel5Value ?? 0].levelTitle ?? String.empty
            body = levelMessages[domainModel?.currentGetToLevel5Value ?? 0].levelContent
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        return super.isContentEqual(to: source) &&
            domainModel?.latestGetToLevel5Value == source.domainModel?.latestGetToLevel5Value &&
            domainModel?.currentGetToLevel5Value == source.domainModel?.currentGetToLevel5Value
    }
}
