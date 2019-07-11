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
    var iconName: String
    var type: MyLibraryCategoryType

    func infoText() -> String {
        // FIXME: change to localized string
        var info = "\(itemCount) item"
        if itemCount != 1 {
            info += "s"
        }

        if let date = lastUpdated {
            // FIXME: change to localized string
            info += "| Last update \(DateFormatter.ddMMM.string(from: date))"
        }

        return info
    }
}
