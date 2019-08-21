//
//  GuidedTrackViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class GuidedTrackViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var guidedTrackList = [GuideTrackModelItem]()

    // MARK: - Init
    init(domainModel: QDMDailyBriefBucket?) {
        super.init(domainModel)
    }
}
