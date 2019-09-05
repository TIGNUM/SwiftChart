//
//  BeSpokeCellViewModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class BeSpokeCellViewModel: BaseDailyBriefViewModel {

    // MARK: - PROPERTIES
    var title: String?
    var description: String?
    let image: String?
    let bucketTitle: String?

    // MARK: - INIT
    init(bucketTitle: String?, title: String?, description: String?, image: String?, domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.description = description
        self.image = image
        self.bucketTitle = bucketTitle
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? BeSpokeCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            title == source.title &&
            image == source.image &&
            description == source.description &&
            bucketTitle == source.bucketTitle
    }
}
