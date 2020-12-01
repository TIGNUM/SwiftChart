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

    // MARK: - Init
    init(title: String?,
         thought: String?,
         author: String?,
         image: String?,
         domainModel: QDMDailyBriefBucket?) {
        self.thought = thought
        self.author = author
        super.init(domainModel,
                   caption: title,
                   title: thought,
                   body: author,
                   image: image)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? ThoughtsCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
        thought == source.thought &&
        author == source.author &&
        title == source.title
    }

}
