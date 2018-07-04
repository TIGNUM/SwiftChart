//
//  SigningInfoModel.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

struct SigningInfoModel {

    enum Slide {
        case first
        case second
        case third
        case fourth

        static var allSlides: [Slide] {
            return [.first, .second, .third, .fourth]
        }

        var title: String {
            switch self {
            case .first: return R.string.localized.signingInfo01Title()
            case .second: return R.string.localized.signingInfo02Title()
            case .third: return R.string.localized.signingInfo03Title()
            case .fourth: return R.string.localized.signingInfo04Title()
            }
        }

        var body: String {
            switch self {
            case .first: return R.string.localized.signingInfo01Body()
            case .second: return R.string.localized.signingInfo02Body()
            case .third: return R.string.localized.signingInfo03Body()
            case .fourth: return R.string.localized.signingInfo04Body()
            }
        }
    }
}
