//
//  SlideShowModels.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum SlideShow {

    enum Page {
        case titleSlide(title: String, imageName: String)
        case titleSubtitleSlide(title: String, subtitle: String, imageName: String)
        case morePrompt(title: String, subtitle: String, doneButtonTitle: String, moreButtonTitle: String)
        case completePrompt(title: String, doneButtonTitle: String)
    }

    struct Slide: Codable {
        let title: String
        let subtitle: String?
        let imageName: String
    }
}

extension SlideShow.Page: Equatable {

    static func == (lhs: SlideShow.Page, rhs: SlideShow.Page) -> Bool {
        switch (lhs, rhs) {
        case let (.titleSlide(a), .titleSlide(b)):
            return a == b
        case let (.titleSubtitleSlide(a), .titleSubtitleSlide(b)):
            return a == b
        case let (.morePrompt(a), .morePrompt(b)):
            return a == b
        case let (.completePrompt(a), .completePrompt(b)):
            return a == b
        default:
            return false
        }
    }
}
