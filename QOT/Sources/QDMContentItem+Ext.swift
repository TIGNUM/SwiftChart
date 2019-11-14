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
            let min = String(format: "%.0f", max((valueDuration ?? 60), 1) / 60)
            switch format {
            case .audio: return String(format: AppTextService.get(AppTextKey.generic_content_section_item_label_audio), min)
            case .video: return String(format: AppTextService.get(AppTextKey.generic_content_section_item_label_video), min)
            case .pdf: return String(format: AppTextService.get(AppTextKey.generic_content_section_item_label_read), min)
            default: return ""
            }
        }
    }
}
