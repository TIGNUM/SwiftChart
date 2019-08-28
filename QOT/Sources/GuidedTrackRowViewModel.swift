//
//  GuidedTrackRowViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class GuidedTrackRowViewModel: BaseDailyBriefViewModel, GuideTrackModelItem {

    // MARK: - Properties
    var heading: String?
    var title: String?
    var content: String?
    var buttonText: String?

    var type: GuidedTrackItemType {
        return .ROW
    }

    // MARK: - Init
    internal init(heading: String?, title: String?, content: String?, buttonText: String?, domain: QDMDailyBriefBucket) {
        self.heading = heading
        self.title = title
        self.content = content
        self.buttonText = buttonText
        super.init(domain)
    }

}
