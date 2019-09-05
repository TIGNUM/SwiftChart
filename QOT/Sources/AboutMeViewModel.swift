//
//  AboutMeViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 30.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class AboutMeViewModel: BaseDailyBriefViewModel {
    // MARK: - Properties
    let title: String?
    let aboutMeContent: String?
    let aboutMeMoreInfo: String?

    // MARK: - Init
   init(title: String?, aboutMeContent: String?, aboutMeMoreInfo: String?, domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.aboutMeContent = aboutMeContent
        self.aboutMeMoreInfo = aboutMeMoreInfo
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? AboutMeViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            title == source.title &&
            aboutMeContent == source.aboutMeContent &&
            aboutMeMoreInfo == source.aboutMeMoreInfo
    }
}
