//
//  OnboardingLandingPageWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 02/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class OnboardingLandingPageWorker {

    // MARK: - Properties

    let infoController: SigningInfoViewControllerInterface
    let loginController: OnboardingLoginViewControllerInterface
    let tbvContentCategory: QDMContentCategory?

    // MARK: - Init

    init(infoController: SigningInfoViewControllerInterface,
         loginController: OnboardingLoginViewControllerInterface,
         tbvContentCategory: QDMContentCategory?) {
        self.infoController = infoController
        self.loginController = loginController
        self.tbvContentCategory = tbvContentCategory
    }
}
