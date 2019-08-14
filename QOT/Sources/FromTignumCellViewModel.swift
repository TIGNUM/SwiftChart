//
//  FromTignumCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class FromTignumCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var text: String?
    var title: String?

    // MARK: - Init
    init(title: String?, text: String?, domainModel: QDMDailyBriefBucket?) {
        self.text = text
        self.title = title
        super.init(domainModel)
    }
}
