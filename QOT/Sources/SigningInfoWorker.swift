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

    // MARK: - Init
    init(model: SigningInfoModel) {
        self.model = model
    }

    // MARK: - Texts
    lazy var titleText: String? = {
        return AppTextService.get(AppTextKey.singin_onboarding_view_intro_title)
    }()

    var bodyText: String? = {
        return AppTextService.get(AppTextKey.singin_onboarding_view_intro_body)
    }()
}

// MARK: - Public
extension SigningInfoWorker {
    func shouldShowUnoptimizedScreenWarning() -> Bool {
        return UIDevice.isPad || UIDevice.isSmallScreenDevice
    }
}
