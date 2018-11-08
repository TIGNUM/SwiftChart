//
//  SigningInfoWorker.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoWorker {

    // MARK: - Properties

    private let model: SigningInfoModel
    private let services: Services

    // MARK: - Init

    init(model: SigningInfoModel, services: Services) {
        self.model = model
        self.services = services
    }
}

// MARK: - Public

extension SigningInfoWorker {

    var numberOfSlides: Int {
        return SigningInfoModel.Slide.allSlides.count
    }

    func title(at item: Int) -> String? {
        return contentItem(at: item, format: "title")?.valueText
    }

    func body(at item: Int) -> String? {
        return contentItem(at: item, format: "body")?.valueText
    }
}

// MARK: - Private

private extension SigningInfoWorker {

    func contentItem(at item: Int, format: String) -> ContentItem? {
        let contentID = SigningInfoModel.Slide.allSlides[item].contentID
        guard let content = services.contentService.contentCollection(id: contentID) else { return nil }
        return Array(content.contentItems).filter { $0.format == format }.first
    }
}
