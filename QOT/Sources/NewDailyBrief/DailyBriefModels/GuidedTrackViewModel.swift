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
    var items: [GuidedTrackItem]?

    // MARK: - Init
    internal init(title: String?,
                  items: [GuidedTrackItem]?,
                  domain: QDMDailyBriefBucket) {
        self.items = items
        super.init(domain)
        self.title = title
        self.attributedTitle = ThemeText.dailyBriefTitle.attributedString(title)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? GuidedTrackViewModel else { return false }
        return super.isContentEqual(to: source) &&
                title == source.title &&
                items == source.items
    }
}
