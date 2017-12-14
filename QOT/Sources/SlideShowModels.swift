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
        case slide(title: String, subtitle: String, imageName: String)
        case prompt(title: String, showMoreButton: Bool)
    }

    struct Slide: Codable {
        let title: String
        let subtitle: String
        let imageName: String
    }
}

extension SlideShow.Page: Equatable {

    static func == (lhs: SlideShow.Page, rhs: SlideShow.Page) -> Bool {
        switch (lhs, rhs) {
        case let (.slide(a), .slide(b)):
            return a == b
        case let (.prompt(a), .prompt(b)):
            return a == b
        default:
            return false
        }
    }
}
