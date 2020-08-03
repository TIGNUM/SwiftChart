//
//  TeamVisionSuggestionModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 31.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

final class TeamVisionSuggestionModel {

    // MARK: - Properties
    let title: String?
    let tbvSentence: String?
    let adviceText: String?

    // MARK: - Init
    init(title: String?, tbvSentence: String?, adviceText: String?) {
        self.title = title
        self.tbvSentence = tbvSentence
        self.adviceText = adviceText
    }
}
