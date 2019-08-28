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
    var subIdentifier = ""

    // MARK: - Init
    init(_ domainModel: QDMDailyBriefBucket?, _ subIdentifier: String? = "") {
        self.domainModel = domainModel
        self.subIdentifier = subIdentifier ?? ""
    }
}

    // MARK: - Public
extension BaseDailyBriefViewModel {
    var differenceIdentifier: DifferenceIdentifier {
        return (self.domainModel?.bucketName ?? "") + subIdentifier
    }

    func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier
    }
}
