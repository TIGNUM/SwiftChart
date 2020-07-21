//
//  BookMarkSelectionModel.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct BookMarkSelectionModel {
    let team: QDMTeam?
    let storage: QDMUserStorage?
    var isSelected: Bool = false
    lazy var isTeamBookMark = {
        return team != nil
    }()

    lazy var canRemove = {
        return isTeamBookMark == false || (storage?.isMine ?? false)
    }()

    init(_ team: QDMTeam?, _ storage: QDMUserStorage?) {
        self.team = team
        self.storage = storage
        if self.storage != nil {
            isSelected = true
        }
    }
}
