//
//  TutorialModel.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

struct TutorialModel {

    enum ItemType: String {
        case title
        case subtitle
        case body
        case image

        var font: UIFont {
            switch self {
            case .title: return .H1TitleRegular
            case .subtitle: return .H2SubtitleLight
            case .body: return .ApercuRegular15
            case .image: return .ApercuRegular15
            }
        }

        var format: String {
            return self.rawValue
        }
    }

    enum Slide {
        case guide
        case learn
        case tbv
        case data
        case prepare

        static var allSlides: [Slide] {
            return [.guide, .learn, .tbv, .data, .prepare]
        }

        var contentID: Int {
            switch self {
            case .guide: return 100759
            case .learn: return 100760
            case .tbv: return 100770
            case .data: return 100771
            case .prepare: return 100776
            }
        }
    }
}
