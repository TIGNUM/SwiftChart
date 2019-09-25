//
//  MyLibraryCategoryListModel.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

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
            info = R.string.localized.myLibraryGroupItemCountSingular("\(itemCount)")
        } else {
            info = R.string.localized.myLibraryGroupItemCountPlural("\(itemCount)")
        }

        if let date = lastUpdated {
            let stringDate = DateFormatter.ddMMM.string(from: date)
            info += R.string.localized.myLibraryGroupLastUpdate(stringDate)
        }

        return info
    }
}
