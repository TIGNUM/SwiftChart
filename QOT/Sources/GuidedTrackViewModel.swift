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
    var bucketTitle: String?
    var levelTitle: String?
    var content: String?
    var buttonText: String?
    var appLink: QDMAppLink?
    var type: GuidedTrackItemType?

    // MARK: - Init
    internal init(bucketTitle: String = "", levelTitle: String, content: String?, buttonText: String?, type: GuidedTrackItemType?, appLink: QDMAppLink?, domain: QDMDailyBriefBucket) {
        self.bucketTitle = bucketTitle
        self.levelTitle = levelTitle
        self.content = content
        self.buttonText = buttonText
        self.appLink = appLink
        self.type = type
        super.init(domain)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? GuidedTrackViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
        bucketTitle == source.bucketTitle &&
        levelTitle == source.levelTitle &&
        content == source.content &&
        buttonText == source.buttonText
    }
}
