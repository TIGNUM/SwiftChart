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
    lazy var title: String? = {
        return "contentItem(at: item, format: .title)?.valueText.uppercased()"
    }()

    var body: String? = {
        return "contentItem(at: item, format: .body)?.valueText.uppercased()"
    }()
}

// MARK: - Public
extension SigningInfoWorker {
    func shouldShowUnoptimizedScreenWarning() -> Bool {
        return UIDevice.isPad || UIDevice.isSmallScreenDevice
    }
}
