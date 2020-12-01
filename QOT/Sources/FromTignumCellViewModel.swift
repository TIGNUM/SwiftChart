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
    var subtitle: String?
    var cta: String?
    var link: QDMAppLink?

    // MARK: - Init
    init(title: String?,
         text: String?,
         subtitle: String?,
         image: String?,
         cta: String?,
         link: QDMAppLink?,
         domainModel: QDMDailyBriefBucket?) {
        self.text = text
        self.subtitle = subtitle
        self.cta = cta
        self.link = link
        super.init(domainModel,
                   caption: title,
                   title: subtitle,
                   body: text,
                   image: image)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? FromTignumCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            text == source.text &&
            title == source.title &&
            cta == source.cta &&
            subtitle == source.subtitle
    }
}
