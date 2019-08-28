//
//  GuidedTrackSectionCellViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class GuidedTrackSectionViewModel: BaseDailyBriefViewModel, GuideTrackModelItem {

    // MARK: - Properties
    var bucketTitle: String?
    var content: String?
    var buttonText: String?
    var type: GuidedTrackItemType {
        return .SECTION
    }

    // MARK: - Init
    internal init(bucketTitle: String?, content: String?, buttonText: String?, domain: QDMDailyBriefBucket) {
        self.bucketTitle = bucketTitle
        self.content = content
        self.buttonText = buttonText
        super.init(domain)
    }

//    // MARK: - Properties
//    var guidedTrackList = [GuideTrackModelItem]()

    // MARK: - Init
    init(domainModel: QDMDailyBriefBucket?) {
        super.init(domainModel)
    }
}
