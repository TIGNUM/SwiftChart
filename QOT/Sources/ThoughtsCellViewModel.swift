//
//  ThoughtsCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ThoughtsCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var thought: String?
    var author: String?
    var title: String?

    // MARK: - Init
    init(title: String?, thought: String?, author: String?, domainModel: QDMDailyBriefBucket?) {
        self.thought = thought
        self.author = author
        self.title = title
        super.init(domainModel)
    }
}
