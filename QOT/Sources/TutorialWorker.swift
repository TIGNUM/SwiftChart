//
//  TutorialWorker.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class TutorialWorker {

    // MARK: - Properties

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }
}

// MARK: - Public

extension TutorialWorker {

    var numberOfSlides: Int {
        return TutorialModel.Slide.allSlides.count
    }

    func title(at index: Index) -> String? {
        return contentItem(at: index, and: .title)?.valueText
    }

    func subtitle(at index: Index) -> String? {
        return contentItem(at: index, and: .subtitle)?.valueText
    }

    func body(at index: Index) -> String? {
        return contentItem(at: index, and: .body)?.valueText
    }

    func imageURL(at index: Index) -> URL? {
        guard let imageURLString = contentItem(at: index, and: .image)?.valueImageURL else { return nil }
        return URL(string: imageURLString)
    }

    func attributedbuttonTitle(at index: Index) -> NSAttributedString {
        let title = index == TutorialModel.Slide.allSlides.count - 1 ? R.string.localized.buttonTitleStart() : R.string.localized.buttonTitleSkip()
        return NSAttributedString(string: title,
                                  letterSpacing: 0,
                                  font: .ApercuBold14,
                                  textColor: .azure,
                                  alignment: .center)
    }
}

// MARK: - Private

private extension TutorialWorker {

    func contentItem(at index: Index, and type: TutorialModel.ItemType) -> ContentItem? {
        let identifier = TutorialModel.Slide.allSlides[index].contentID
        let content = services.contentService.contentCollection(id: identifier)
        return content?.contentItems.filter { $0.format == type.format }.first
    }
}
