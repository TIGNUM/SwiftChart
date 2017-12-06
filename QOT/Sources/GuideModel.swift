//
//  GuideViewModel.swift
//  QOT
//
//  Created by karmic on 29.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

struct GuideModel {

    enum Status {
        case open
        case done

        var color: UIColor {
            switch self {
            case .done: return .lightGray
            case .open: return .white
            }
        }
    }

    struct DailyPlan {
        var items: [ViewModel]
    }

    struct ViewModel {
        var title: String?
        var content: String?
        var type: String?
        var status: Status
        var plan: String?
    }
}
