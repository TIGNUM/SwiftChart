//
//  MyStatisticsData.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

enum DataDisplayColor {
    case above
    case inBetween
    case below

    var color: UIColor {
        switch self {
        case .above:
            return .cherryRed
        case .inBetween:
            return .gray
        case .below:
            return UIColor.white
        }
    }
}

protocol MyStatisticsData {
    var displayType: DataDisplayType { get set }
}

typealias StatisticsThreshold<T> = (upperThreshold: T, lowerThreshold: T)
