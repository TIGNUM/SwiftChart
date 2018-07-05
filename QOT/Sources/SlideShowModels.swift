//
//  SlideShowModels.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum SlidesType {
    case initialInstall
    case helpMenu
}

enum SlideShow {

    enum Page {
        case titleSlide(title: String, imageURL: URL)
        case titleSubtitleSlide(title: String, subtitle: String, imageURL: URL)
        case completePrompt
    }

    struct Slide: Codable {
        let title: String
        let subtitle: String?
        let imageURL: URL
    }
}

extension SlideShow.Page: Equatable {

    static func == (lhs: SlideShow.Page, rhs: SlideShow.Page) -> Bool {
        switch (lhs, rhs) {
        case let (.titleSlide(a), .titleSlide(b)):
            return a == b
        case let (.titleSubtitleSlide(a), .titleSubtitleSlide(b)):
            return a == b
        case (.completePrompt, .completePrompt):
            return true
        default:
            return false
        }
    }
}
