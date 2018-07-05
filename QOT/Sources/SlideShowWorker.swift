//
//  SlideShowWorker.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SlideShowWorker {

    // MARK: - Properties

    let services: Services?

    // MARK: - Init

    init(services: Services?) {
        self.services = services
    }

    // MARK: - Public

    func slides() -> [SlideShow.Slide] {
        var slides = [SlideShow.Slide]()
        services?.contentService.tutorialSlideShows().forEach { (content: ContentCollection) in
            if
                let title = item(content, format: .textH3)?.valueText,
                let imageURLString = item(content, format: .image)?.valueImageURL,
                let imageURL = URL(string: imageURLString) {
                let subtitle = item(content, format: .textParagraph)?.valueText
                slides.append(SlideShow.Slide(title: title, subtitle: subtitle, imageURL: imageURL))
            }
        }
        return slides
    }
}

// MARK: - Private

private extension SlideShowWorker {

    func item(_ content: ContentCollection, format: ContentItemFormat) -> ContentItem? {
        return Array(content.items).filter { $0.format == format.rawValue }.first
    }
}
