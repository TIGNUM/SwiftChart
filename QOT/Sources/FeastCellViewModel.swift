//
//  FeastCellViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class FeastCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var title: String?
    var image: String?
    var remoteID: Int?

    // MARK: - Init
    internal init(title: String?, image: String?, remoteID: Int?, domainModel: QDMDailyBriefBucket?) {
        self.image = image
        self.title = title
        self.remoteID = remoteID
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? FeastCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            title == source.title &&
            image == source.image &&
            remoteID == source.remoteID
    }
}
