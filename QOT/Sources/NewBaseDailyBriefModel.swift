//
//  NewBaseDailyBriefModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 03/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//
import Foundation
import qot_dal

 class NewBaseDailyBriefModel: BaseDailyBriefViewModel, DynamicHeightProtocol {

    // MARK: - Init
    init(domainModel: QDMDailyBriefBucket?) {
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? NewBaseDailyBriefModel else {
            return false
        }
        return super.isContentEqual(to: source)
    }

    // MARK: - Public
    public func height(forWidth width: CGFloat) -> CGFloat {
        return 0
    }
}
