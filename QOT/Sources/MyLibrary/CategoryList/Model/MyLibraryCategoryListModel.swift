//
//  MyLibraryCategoryListModel.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum MyLibraryCategoryType: String {
    case ALL = "UNKOWN"
    case BOOKMARKS = "BOOKMARK"
    case DOWNLOADS = "DOWNLOAD"
    case LINKS = "EXTERNAL_LINK"
    case NOTES = "NOTE"
}

struct MyLibraryCategoryListModel {
    var title: String
    var itemCount: Int
    var lastUpdated: Date?
    var icon: UIImage?
    var type: MyLibraryCategoryType
    var hasNewItem: Bool = false

    func infoText() -> String {
        var info: String
        if itemCount == 1 {
            info = AppTextService.get(.my_qot_my_library_subtitle_item_new_title_group_singular).replacingOccurrences(of: "${COUNT}", with: "\(itemCount)")
        } else {
            info = AppTextService.get(.my_qot_my_library_subtitle_items_new_title_group_plural).replacingOccurrences(of: "${COUNT}", with: "\(itemCount)")
        }

        if let date = lastUpdated {
            let stringDate = DateFormatter.ddMMM.string(from: date)
            info += AppTextService.get(.my_qot_my_library_subtitle_last_updated_new_title_group_last_update).replacingOccurrences(of: "${DATE}", with: stringDate)
        }
        return info
    }
}
