//
//  MeAtMyBestEmptyViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MeAtMyBestCellEmptyViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var title: String?
    var intro: String?
    var buttonText: String?

    // MARK: - Init
    init(title: String?, intro: String?, buttonText: String?, domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.intro = intro
        self.buttonText = buttonText
        super.init(domainModel)
    }
}
