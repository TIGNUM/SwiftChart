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
    var image: URL?
    var title: String?

    // MARK: - Init
    init(title: String?, fact: String?, image: URL?, domainModel: QDMDailyBriefBucket?) {
        self.fact = fact
        self.image = image
        self.title = title
        super.init(domainModel)
    }
}
