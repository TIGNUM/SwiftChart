//
//  TutorialViewModel.swift
//  QOT
//
//  Created by Moucheg Mouradian on 24/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Rswift

import LoremIpsum

class TutorialViewModel: NSObject {

    // MARK: - Properties

    let tutorial: Tutorial

    lazy var title: String = {
        switch self.tutorial {
        case .learn:
            return "01/03 \(R.string.localized.tabBarItemLearn())"
        case .me:
            return "02/03 \(R.string.localized.tabBarItemMe())"
        case .prepare:
            return "03/03 \(R.string.localized.tabBarItemPrepare())"
        }
    }()

    lazy var content: String = {
        switch self.tutorial {
        case .learn:
            return R.string.localized.tutorialLearnText()
        case .me:
            return R.string.localized.tutorialMeText()
        case .prepare:
            return R.string.localized.tutorialPrepareText()
        }
    }()

    // MARK: - Methods

    init(tutorial: Tutorial) {
        self.tutorial = tutorial
    }
}
