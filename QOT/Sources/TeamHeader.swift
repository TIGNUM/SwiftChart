//
//  TeamHeader.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

class TeamHeader {
    let teamId: String
    var title: String
    var hexColorString: String
    var sortOrder: Int
    var batchCount: Int
    var selected: Bool

    internal init(teamId: String,
                  title: String,
                  hexColorString: String,
                  sortOrder: Int,
                  batchCount: Int,
                  selected: Bool) {
         self.teamId = teamId
         self.title = title
         self.hexColorString = hexColorString
         self.sortOrder = sortOrder
         self.batchCount = batchCount
         self.selected = selected
     }
}
