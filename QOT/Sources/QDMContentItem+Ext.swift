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

        let min = String(format: "%.0f", max((valueDuration ?? 60), 1) / 60)
        switch format {
        case .audio: return AppTextService.get(.generic_content_section_item_new_label_audio).replacingOccurrences(of: "${AMOUNT}", with: min)
        case .video: return AppTextService.get(.generic_content_section_item_new_label_video).replacingOccurrences(of: "${AMOUNT}", with: min)
        case .pdf: return AppTextService.get(.generic_content_section_item_new_label_pdf).replacingOccurrences(of: "${AMOUNT}", with: min)
        default: return ""
        }
    }
}
