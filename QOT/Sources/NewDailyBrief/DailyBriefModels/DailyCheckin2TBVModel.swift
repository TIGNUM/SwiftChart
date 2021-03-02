//
//  DailyCheckinInsightsTBVViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 02.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckIn2TBVModel {

    // MARK: - Properties
    let title: String?
    let introText: String?
    let tbvSentence: String?
    let adviceText: String?
    let cta: String?

    // MARK: - Init
    init(title: String?, introText: String?, tbvSentence: String?, adviceText: String?, cta: String?) {
        self.title = title
        self.introText = introText
        self.tbvSentence = tbvSentence
        self.adviceText = adviceText
        self.cta = cta
    }
}
