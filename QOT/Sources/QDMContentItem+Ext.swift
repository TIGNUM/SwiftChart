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
            case .audio: return String(format: AppTextService.get(AppTextKey.audio_list_duration_title), min)
            case .video: return String(format: AppTextService.get(AppTextKey.video_list_duration_title), min)
            case .pdf: return String(format: AppTextService.get(AppTextKey.pdf_list_duration_title), min)
            default: return ""
            }
        }
    }
}
