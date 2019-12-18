//
//  MyQotAdminSettingsListWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

public struct dailyCheckinQuestionsPriorities: Codable {
    static var tbvShpiPeak: [Int] = [0, 1, 2]
    static var tbvPeakShpi: [Int] = [0, 2, 1]
    static var shpiTbvPeak: [Int] = [1, 0, 2]
    static var shpiPeakTbv: [Int] = [1, 2, 0]
    static var peakTbvShpi: [Int] = [2, 0, 1]
    static var peakShpiTbv: [Int] = [2, 1, 0]
}

public enum dailyCheckinQuestionPriorityString: String {
    case tbvShpiPeak = "TBV - SHPI - PEAK"
    case tbvPeakShpi = "TBV - PEAK - SHPI"
    case shpiTbvPeak = "SHPI - TBV - PEAK"
    case shpiPeakTbv = "SHPI - PEAK - TBV"
    case peakTbvShpi = "PEAK - TBV - SHPI"
    case peakShpiTbv = "PEAK - SHPI - TBV"
}

final class MyQotAdminSettingsListWorker {

    var currentSixthQuestionSetting: [Int] = dailyCheckinQuestionsPriorities.tbvShpiPeak
    // MARK: - Init
    init() { /**/ }
}
