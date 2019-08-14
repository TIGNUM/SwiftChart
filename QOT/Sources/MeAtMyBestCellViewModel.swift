//
//  MeAtMyBestCellViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 30.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MeAtMyBestCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var title: String?
    var intro: String?
    var tbvStatement: String?
    var intro2: String?
    var buttonText: String?

    // MARK: - Init
    init(title: String?, intro: String?, tbvStatement: String?, intro2: String?, buttonText: String?, domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.intro = intro
        self.tbvStatement = tbvStatement
        self.intro2 = intro2
        self.buttonText = buttonText
        super.init(domainModel)
    }

}
