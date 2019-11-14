//
//  SigningInfoWorker.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SigningInfoWorker {

    // MARK: - Properties
    private let model: SigningInfoModel

    // MARK: - Init
    init(model: SigningInfoModel) {
        self.model = model
    }

    // MARK: - Texts
    lazy var titleText: String? = {
        return R.string.localized.onboardingIntroTitle()
    }()

    var bodyText: String? = {
        return R.string.localized.onboardingIntroBody()
    }()
}

// MARK: - Public
extension SigningInfoWorker {
    func shouldShowUnoptimizedScreenWarning() -> Bool {
        return UIDevice.isPad || UIDevice.isSmallScreenDevice
    }
}
