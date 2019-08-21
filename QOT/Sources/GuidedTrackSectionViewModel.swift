//
//  GuidedTrackSectionCellViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class GuidedTrackSectionViewModel: GuideTrackModelItem {

    // MARK: - Properties
    var bucketTitle: String?
    var content: String?
    var buttonText: String?
    var type: GuidedTrackItemType {
        return .SECTION
    }

    // MARK: - Init
    internal init(bucketTitle: String?, content: String?, buttonText: String?) {
        self.bucketTitle = bucketTitle
        self.content = content
        self.buttonText = buttonText
    }
}
