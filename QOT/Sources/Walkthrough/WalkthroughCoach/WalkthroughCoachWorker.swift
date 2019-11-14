//
//  WalkthroughCoachWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class WalkthroughCoachWorker {

    // MARK: - Properties
    lazy var text: String = {
        return AppTextService.get(AppTextKey.onboarding_walkthrough_coach_section_body_body)
    }()

    // MARK: - Init

    init() {
    }
}
