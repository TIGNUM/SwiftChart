//
//  GuidedTrackRowViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class GuidedTrackRowViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var heading: String?
    var title: String?
    var content: String?
    var buttonText: String?
    var levelTitle: String?

    var type: GuidedTrackItemType {
        return .ROW
    }

    // MARK: - Init
    internal init(levelTitle: String,
                  heading: String?,
                  title: String?,
                  content: String?,
                  buttonText: String?,
                  domain: QDMDailyBriefBucket) {
        self.title = title
        self.heading = heading
        self.title = title
        self.content = content
        self.buttonText = buttonText
        super.init(domain)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? GuidedTrackRowViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            title == source.title &&
            heading == source.heading &&
            title == source.title &&
            content == source.content &&
            buttonText == source.buttonText
    }

}
