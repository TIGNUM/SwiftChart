//
//  BaseDailyBrief.swift
//  QOT
//
//  Created by Srikanth Roopa on 01.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import DifferenceKit
import qot_dal
class BaseDailyBriefViewModel: Differentiable {

    // MARK: - Properties
    typealias DifferenceIdentifier = String
    var domainModel: QDMDailyBriefBucket? = nil

    // MARK: - Init
    init(_ domainModel: QDMDailyBriefBucket?) {
        self.domainModel = domainModel
    }
}

    // MARK: - Public
extension BaseDailyBriefViewModel {
    var differenceIdentifier: DifferenceIdentifier {
        return "-"
    }

    func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier
    }
}
