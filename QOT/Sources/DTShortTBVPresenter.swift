//
//  DTShortTBVPresenter.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTShortTBVPresenter: DTPresenter {

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == ShortTBV.QuestionKey.IntroMindSet
    }
}
