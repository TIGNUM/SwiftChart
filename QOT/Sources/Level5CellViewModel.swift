//
//  Level5CellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 01.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import qot_dal
import Foundation

final class Level5CellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var title: String?
    var intro: String?
    var question: String?
    var youRatedPart1: String?
    var youRatedPart2: String?
    var level1Title: String?
    var level2Title: String?
    var level3Title: String?
    var level4Title: String?
    var level5Title: String?
    var level1Text: String?
    var level2Text: String?
    var level3Text: String?
    var level4Text: String?
    var level5Text: String?
    var comeBackText: String?
    var currentLevel: Int?

    // MARK: - Init
    init(title: String?,
         intro: String?,
         question: String?,
         youRatedPart1: String?,
         youRatedPart2: String?,
         level1Title: String?,
         level2Title: String?,
         level3Title: String?,
         level4Title: String?,
         level5Title: String?,
         level1Text: String?,
         level2Text: String?,
         level3Text: String?,
         level4Text: String?,
         level5Text: String?,
         comeBackText: String?,
         domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.intro = intro
        self.question = question
        self.youRatedPart1 = youRatedPart1
        self.youRatedPart2 = youRatedPart2
        self.level1Title = level1Title
        self.level2Title = level2Title
        self.level3Title = level3Title
        self.level4Title = level4Title
        self.level5Title = level5Title
        self.level1Text = level1Text
        self.level2Text = level2Text
        self.level3Text = level3Text
        self.level4Text = level4Text
        self.level5Text = level5Text
        self.comeBackText = comeBackText
        super.init(domainModel)
    }
}
