//
//  ExploreCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ExploreCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var introText: String?
    var bucketTitle: String?
    var title: String?
    var remoteID: Int?
    var duration: String?
    var section: ContentSection

    // MARK: - Init
    init(bucketTitle: String?, title: String?, introText: String?, remoteID: Int?, duration: String?, domainModel: QDMDailyBriefBucket?, section: ContentSection) {
        self.introText = introText
        self.bucketTitle = bucketTitle
        self.title = title
        self.remoteID = remoteID
        self.duration = duration
        self.section = section
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? ExploreCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            introText == source.introText &&
            bucketTitle == source.bucketTitle &&
            title == source.title &&
            remoteID == source.remoteID &&
            duration == source.duration &&
            section == source.section
    }
}
