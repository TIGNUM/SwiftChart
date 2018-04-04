//
//  SlideShowWorker.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SlideShowWorker {

    enum DataError: Error {
        case missingData
    }

    let services: Services?

    init(services: Services?) {
        self.services = services
    }

    private func slides() throws -> Slides {
        guard
            let basicSlideCategory = services?.contentService.contentCategory(id: SlideShow.Category.basic.rawValue),
            let extendedSlideCategory = services?.contentService.contentCategory(id: SlideShow.Category.extended.rawValue) else {
                throw DataError.missingData
        }

        let basicSlideContent = basicSlideCategory.contentCollections.sorted(by: [.sortOrder()])
        let extendedSlideContent = extendedSlideCategory.contentCollections.sorted(by: [.sortOrder()])
        var basic = [SlideShow.Slide]()
        var extended = [SlideShow.Slide]()

        try basicSlideContent.forEach { (content: ContentCollection) in
            guard
                let title = item(content, format: .textH3)?.valueText,
                let subtitle = item(content, format: .textParagraph)?.valueText,
                let imageURLString = item(content, format: .image)?.valueImageURL,
                let imageURL = URL(string: imageURLString) else { throw DataError.missingData }
            basic.append(SlideShow.Slide(title: title, subtitle: subtitle, imageURL: imageURL))
        }

        try extendedSlideContent.forEach { (content: ContentCollection) in
            guard
                let title = item(content, format: .textH3)?.valueText,
                let imageURLString = item(content, format: .image)?.valueImageURL,
                let imageURL = URL(string: imageURLString) else { throw DataError.missingData }
            extended.append(SlideShow.Slide(title: title, subtitle: nil, imageURL: imageURL))
        }

        return Slides(basic: basic, extended: extended)
    }

    private func item(_ content: ContentCollection, format: ContentItemFormat) -> ContentItem? {
        return Array(content.items).filter { $0.format == format.rawValue }.first
    }

    var basicSlides: [SlideShow.Slide] {
        do {
            return try slides().basic
        } catch {
            assertionFailure("Failed to load basic slides: \(error)")
            return []
        }
    }

    var extendedSlides: [SlideShow.Slide] {
        do {
            return try slides().extended
        } catch {
            assertionFailure("Failed to load extended slides: \(error)")
            return []
        }
    }
}

private struct Slides {

    let basic: [SlideShow.Slide]
    let extended: [SlideShow.Slide]
}
