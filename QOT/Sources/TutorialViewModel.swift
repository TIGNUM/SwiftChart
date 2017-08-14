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

    let tutorial: Tutorials
    let buttonFrame: CGRect?
    let completion: () -> Void

    lazy var title: String = {
        switch self.tutorial {
        case .learnTutorial:
            return "01/03 \(R.string.localized.tabBarItemLearn())"
        case .meTutorial:
            return "02/03 \(R.string.localized.tabBarItemMe())"
        case .prepareTutorial:
            return "03/03 \(R.string.localized.tabBarItemPrepare())"
        }
    }()

    lazy var content: String = {
        switch self.tutorial {
        case .learnTutorial:
            return R.string.localized.tutorialLearnText()
        case .meTutorial:
            return R.string.localized.tutorialMeText()
        case .prepareTutorial:
            return R.string.localized.tutorialPrepareText()
        }
    }()

    // MARK: - Methods

    init(tutorial: Tutorials, buttonFrame: CGRect?, completion: @escaping () -> Void) {
        self.tutorial = tutorial
        self.buttonFrame = buttonFrame
        self.completion = completion
    }

}
