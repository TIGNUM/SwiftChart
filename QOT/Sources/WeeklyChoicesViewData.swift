//
//  WeeklyChoicesViewData.swift
//  QOT
//
//  Created by Lee Arromba on 23/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct WeeklyChoicesViewData {
    struct Page {
        struct Item {
            let title: String?
            var subtitle: String?
            let categoryName: String?
            let contentCollectionID: Int?
            let categoryID: Int?
        }
        
        let startDate: Date
        let endDate: Date
        let dateString: String
        let items: [Item]
        
        init(startDate: Date, endDate: Date, dateString: String, items: [Item]) {
            self.startDate = startDate
            self.endDate = endDate
            self.dateString = dateString
            self.items = items
        }
    }
    
    let pages: [Page]
    let itemsPerPage: Int
}
