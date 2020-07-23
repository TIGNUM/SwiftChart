//
//  BookMarkSelectionModel.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class BookMarkSelectionModel {
    let team: QDMTeam?
    let storage: QDMUserStorage?
    var isSelected: Bool = false
    lazy var isTeamBookMark = {
        return team != nil
    }()

    lazy var canEdit = { () -> Bool in
        if let storage = self.storage {
            return storage.isMine ?? false
        }
        return true
    }()

    init(_ team: QDMTeam?, _ storage: QDMUserStorage?) {
        self.team = team
        self.storage = storage
        if self.storage != nil {
            isSelected = true
        }
    }
}
