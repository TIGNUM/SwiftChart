//
//  SigningInfoWorker.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SigningInfoWorker {

    // MARK: - Properties
    private let model: SigningInfoModel
    private let contentCategory: QDMContentCategory?

    // MARK: - Init
    init(model: SigningInfoModel, contentCategory: QDMContentCategory?) {
        self.model = model
        self.contentCategory = contentCategory
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
