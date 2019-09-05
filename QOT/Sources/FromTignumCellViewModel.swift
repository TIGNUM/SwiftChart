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
    var subtitle: String?

    // MARK: - Init
    init(title: String?, text: String?, subtitle: String?, domainModel: QDMDailyBriefBucket?) {
        self.text = text
        self.title = title
        self.subtitle = subtitle
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? FromTignumCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            text == source.text &&
            title == source.title &&
            subtitle == source.subtitle
    }
}
