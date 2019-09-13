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
}

// MARK: - Public
extension SigningInfoWorker {
    var numberOfSlides: Int {
        return SigningInfoModel.Slide.allSlides.count
    }

    func title(at item: Int) -> String? {
        return contentItem(at: item, format: .title)?.valueText.uppercased()
    }

    func body(at item: Int) -> String? {
        return contentItem(at: item, format: .body)?.valueText.uppercased()
    }

    func shouldShowUnoptimizedScreenWarning() -> Bool {
        return UIDevice.isPad || UIDevice.isSmallScreenDevice
    }
}

// MARK: - Private
private extension SigningInfoWorker {
    func contentItem(at item: Int, format: ContentFormat) -> QDMContentItem? {
        let contentID = SigningInfoModel.Slide.allSlides[item].contentID
        let contentCollection = contentCategory?.contentCollections.filter { $0.remoteID == contentID }.first
        return Array(contentCollection?.contentItems ?? []).filter { $0.format == format }.first
    }
}
