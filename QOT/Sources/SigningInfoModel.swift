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
        case first(title: String, body: String)
        case second(title: String, body: String)
        case third(title: String, body: String)
        case fourth(title: String, body: String)
        case fifth(title: String, body: String)

        var contentID: Int {
            switch self {
            case .first: return 101663
            case .second: return 101662
            case .third: return 101664
            case .fourth: return 101665
            case .fifth: return 101666
            }
        }
    }
}
