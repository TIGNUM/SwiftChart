//
//  GoodToKnowCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class GoodToKnowCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var fact: String?
    var title: String?
    var copyright: String?

    // MARK: - Init
    init(title: String?, fact: String?, copyright: String?, domainModel: QDMDailyBriefBucket?) {
        self.fact = fact
        self.title = title
        self.copyright = copyright
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? GoodToKnowCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
                fact == source.fact &&
                title == source.title &&
                copyright == source.copyright
    }
}
