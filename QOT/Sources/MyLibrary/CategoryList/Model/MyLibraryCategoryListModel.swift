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
    case ALL
    case BOOKMARKS
    case DOWNLOADS
    case LINKS
    case NOTES
}

struct MyLibraryCategoryListModel {
    var title: String
    var itemCount: Int
    var lastUpdated: Date?
    var icon: UIImage?
    var type: MyLibraryCategoryType

    func infoText() -> String {
        var info: String
        if itemCount == 1 {
            info = AppTextService.get(.my_qot_my_library_subtitle_item_new_title_group_singular).replacingOccurrences(of: "($count)", with: "\(itemCount)")
        } else {
            info = AppTextService.get(.my_qot_my_library_subtitle_items_new_title_group_plural).replacingOccurrences(of: "($count)", with: "\(itemCount)")
        }

        if let date = lastUpdated {
            let stringDate = DateFormatter.ddMMM.string(from: date)
            info += String(format: AppTextService.get(.my_qot_my_library_subtitle_last_updated_title_group_last_update), stringDate)
        }

        return info
    }
}
