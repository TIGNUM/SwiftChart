//
//  QuestionCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class QuestionCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var text: String?

    // MARK: - Init
    init(title: String?,
         text: String?,
         image: String?,
         domainModel: QDMDailyBriefBucket?) {
        self.text = text
        super.init(domainModel,
                   caption: title,
                   title: text,
                   image: image)
    }
}
