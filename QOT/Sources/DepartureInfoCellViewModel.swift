//
//  DepartureInfoCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DepartureInfoCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var subtitle: String?
    var title: String?
    var text: String?
    var image: String?
    var copyright: String?

    // MARK: - Init
    init(title: String?, subtitle: String?, text: String?, image: String?, copyright: String?, domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.subtitle = subtitle
        self.text = text
        self.image = image
        self.copyright = copyright
        super.init(domainModel)
    }
}
