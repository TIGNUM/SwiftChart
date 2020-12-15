//
//  MindsetShifterViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MindsetShifterViewModel: BaseDailyBriefViewModel {
    // MARK: - Properties

    let subtitle: String?
    let mindsetShifter: QDMMindsetShifter?

    // MARK: - Init
    init(caption: String?,
         title: String?,
         body: String?,
         image: String?,
         subtitle: String?,
         mindsetShifter: QDMMindsetShifter?,
         domainModel: QDMDailyBriefBucket?) {
        self.subtitle = subtitle
        self.mindsetShifter = mindsetShifter
        super.init(domainModel, caption: caption, title: title, body: body, image: image)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? MindsetShifterViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            title == source.title &&
            subtitle == source.subtitle
    }
}
