//
//  QDMContentItem+Ext.swift
//  QOT
//
//  Created by karmic on 18.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMContentItem {
    var durationString: String {
        get {
            let min = String(format: "%d", max((valueDuration ?? 60 / 60), 1))
            switch format {
            case .audio: return R.string.localized.learnContentListViewMinutesLabelListen(min)
            case .video: return R.string.localized.learnContentListViewMinutesLabelWatch(min)
            case .pdf: return R.string.localized.learnContentListViewMinutesLabel(min)
            default: return ""
            }
        }
    }
}
