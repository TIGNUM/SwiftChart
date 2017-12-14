//
//  SlideShowWorker.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SlideShowWorker {

    private let plistURL: URL
    private lazy var slides: Slides = {
        do {
            let data = try Data(contentsOf: plistURL)
            let decoder = PropertyListDecoder()
            return try decoder.decode(Slides.self, from: data)
        } catch {
            assertionFailure("Failed to decode slides plist: \(error)")
            return Slides(basic: [], extended: [])
        }
    }()

    init(plistURL: URL) {
        self.plistURL = plistURL
    }

    func basicSlides() -> [SlideShow.Slide] {
        return slides.basic
    }

    func extendedSlides() -> [SlideShow.Slide] {
        return slides.extended
    }
}

private struct Slides: Codable {

    let basic: [SlideShow.Slide]
    let extended: [SlideShow.Slide]
}
